show databases;
use northwind;

select * from customers;
#1List all customers and their contact names
select customername,contactname from customers;

#2Find all order placed by wartian herkku
select sum(od.Quantity) as totalquantity from orders as ord
join customers as cus on ord.CustomerID = cus.CustomerID
join orderdetails as od on ord.OrderID = od.OrderID
where cus.customername = 'wartian herkku';

#3Get a list of products and their unit prices, sorted by price descending.
select ProductName,unit,price from products
order by price desc;

#4List all Customer who are from the city "London".
select * from customers
where city = 'london';

#5Find the total number of customers in each country.
select country,count(CustomerID) totalcustomer from customers
group by country
order by totalcustomer desc;

#6Get the order details for OrderID = 10248, including product name, quantity, and unit price.
select pr.ProductName,od.Quantity,pr.Unit,pr.Price from orderdetails as od
join products as pr on od.ProductID = pr.ProductID
where od.orderid = 10248;

#7Find the total sales for each product.
select pd.ProductName,sum(pd.price*od.quantity) as totalsales from products as pd
join orderdetails as od on pd.ProductID = od.ProductID
group by pd.ProductName;

#8Which employee handled the most orders
select emp.EmployeeID,emp.FirstName,emp.LastName,count(ors.OrderID) as totalorders
from orders ors
join employees emp on ors.EmployeeID = emp.EmployeeID
group by emp.EmployeeID
order by totalorders desc
limit 1;

#9List all products that have never been ordered.
select ProductName,ProductID
from products
where ProductID not in (select distinct(ProductID) from orderdetails);

#10Find the top 5 customers who spent the most in total.
select c.CustomerName,sum(Price) as totalspend from customers c 
join orders o on c.CustomerID = o.CustomerID
join orderdetails od on o.OrderID = od.OrderID
join products p on od.ProductID = p.ProductID
group by c.CustomerName
order by totalspend desc
limit 5;

#11Get the month-wise sales total for 1997.
select monthname(o.orderdate) nameofmonth,month(o.orderdate)  monthnumber,sum(od.Quantity*p.price) totalsale
from orders o
join orderdetails od on o.OrderID = od.OrderID
join products p on od.ProductID = p.ProductID
where year(o.orderdate) = 1997
group by monthnumber,nameofmonth
order by monthnumber;

#12List the top 3 most expensive products in each category.
with RankedProducts as (
    select 
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        c.CategoryName,
        p.Price,
        row_number() over (partition by p.CategoryID order by p.Price DESC)  RankInCategory
    from Products p
    join Categories c on p.CategoryID = c.CategoryID
)
select 
    ProductID,
    ProductName,
    CategoryName,
    Price
from RankedProducts
where RankInCategory <= 3
order by CategoryName, Price desc;

#13Find suppliers who supply more than 5 different products.
select SupplierName ,products_supply 
from(select s.SupplierName,count(ProductName) products_supply from suppliers s 
    join products p on s.SupplierID = p.SupplierID 
    group by s.SupplierName) highsuppliers
where products_supply >=5;