-- CSci 6441 SQL Assignment
-- Hongyi Zhang
-- G38728368
-- hongyi@gwmail.gwu.edu
-- Feb 18, 2011

--1.
SELECT pname FROM parts WHERE id NOT IN ( SELECT pid FROM catalog)

--2.
SELECT S.sname
FROM suppliers S
WHERE NOT EXISTS (
( SELECT P.id FROM parts P )
EXCEPT
( SELECT C.pid FROM catalog C WHERE C.sid = S.id )
)

--3.
SELECT S.sname
FROM suppliers S
WHERE NOT EXISTS (
( SELECT P.id FROM parts P WHERE P.color = 'Red' )
EXCEPT
( SELECT C.pid FROM catalog C, parts P
WHERE C.sid = S.id AND C.pid = P.id AND P.color = 'Red' ))

--4.
SELECT pid 
FROM catalog C,parts P 
WHERE C.sid = (SELECT S.id FROM suppliers S WHERE sname = 'Acme Widget Suppliers')
      AND P.id = C.`pid` 
      AND C.`pid` NOT IN
      (SELECT pid 
      FROM catalog C1,parts P1 WHERE 
      C1.sid != (SELECT S1.id FROM suppliers S1 WHERE sname = 'Acme Widget Suppliers') 
      AND C1.`pid` = P1.id)
            
--5.
SELECT DISTINCT C.sid FROM catalog C WHERE C.cost > ( SELECT AVG (C1.cost)FROM Catalog C1 WHERE C1.pid = C.pid )

--6.
SELECT P.id, S.sname
FROM parts P, suppliers S, catalog C
WHERE C.pid = P.id AND
C.sid = S.id AND
C.cost = ( SELECT MAX(C1.cost)
FROM catalog C1
WHERE C1.pid = P.`id`)

--7.
SELECT S.id
FROM suppliers S
WHERE NOT EXISTS (
SELECT *
FROM catalog C,  parts P
WHERE C.pid = P.id AND C.sid = S.id AND P.color <> 'Red') 

--8.
SELECT DISTINCT C.sid
FROM catalog C, parts P
WHERE C.pid = P.id AND P.color = 'Red'
INTERSECT
SELECT DISTINCT C1.sid
FROM catalog C1, parts P1
WHERE C1.pid = P1.id AND P1.color = 'Green'

--9.
SELECT DISTINCT C.sid
FROM catalog C, parts P
WHERE C.pid = P.id AND P.color = 'Red'
UNION
SELECT DISTINCT C1.sid
FROM catalog C1, parts P1
WHERE C1.pid = P1.id AND P1.color = 'Green'

--10.
SELECT S.sname, COUNT(*) as PartCount
FROM suppliers S, parts P, catalog C
WHERE P.id = C.pid AND C.sid = S.id
GROUP BY S.sname, S.id
HAVING EVERY (P.`color` = 'Green')

--11.
SELECT S.sname, MAX(C.cost) as MaxCost
FROM suppliers S, parts P, catalog C
WHERE P.id = C.pid AND C.sid = S.id
GROUP BY S.sname, S.id
HAVING ANY (P.color = 'Green') AND ANY (P.color = 'Red')



       