<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>欢迎注册</title>
    <meta http-equiv="Content-type" content="text/html; charset=UTF-8"/>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/index/icon.ico" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/regist.css"/>
    <noscript>抱歉，你的浏览器不支持 JavaScript!</noscript>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.4.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/methods.js"></script>
    <script type="text/javascript">
        // 文档就绪事件
        $(function () {
            $("input[name='username']").blur(function () {
                formObj.isNull("username", "用户名不能为空");
                formObj.userNameAvailable("用户名可用", "用户名已被注册");
            });
            $("input[name='password']").blur(function () {
                formObj.isNull("password", "密码不能为空");
            });
            $("input[name='password2']").blur(function () {
                formObj.isNull("password2", "确认密码不能为空");
                formObj.isEqual("password", "password2", "两次密码输入不一致");
            });
            $("input[name='nickname']").blur(function () {
                formObj.isNull("nickname", "昵称不能为空");
            });
            $("input[name='email']").blur(function () {
                formObj.isNull("email", "邮箱不能为空");
                formObj.isRegexValid("email", /^\w+(\.\w+)*@\w+(\.\w+)+$/, "邮箱格式不正确");
            });
            $("input[name='valistr']").blur(function () {
                formObj.isNull("valistr", "验证码不能为空");
            });
        });
        // 表单校验
        let formObj = {
            // 非空校验
            isNull: function (name, msg) {
                let node = $("input[name=" + name + "]");
                if (node.val() == null || node.val() === "") {
                    // 是空
                    node.nextAll("span").text(msg).css("color", "red");
                    return true;
                } else {
                    // 非空
                    node.nextAll("span").text("");
                    return false;
                }
            },
            // 正则表达式校验
            isRegexValid: function (name, regex, msg) {
                let node = $("input[name=" + name + "]");
                if (node.val() === "") {
                    // 空值
                    return false;
                } else if (regex.test(node.val())) {
                    // 正则验证通过
                    node.nextAll("span").text("");
                    return true;
                } else {
                    // 正则不通过
                    node.val("");
                    node.nextAll("span").text(msg).css("color", "red");
                    return false;
                }
            },
            // 值相等校验
            isEqual: function (name1, name2, msg) {
                let node1 = $("input[name=" + name1 + "]");
                let node2 = $("input[name=" + name2 + "]");
                if (node1.val() === node2.val() && node1.val() !== "" && node2.val() !== "") {
                    // 二者相等
                    node1.nextAll("span").text("");
                    return true;
                } else if (node1.val() === "" || node2.val() === "") {
                    // 存在为空的
                    node1.val("");
                    node2.val("");
                } else {
                    // 二者不相等
                    node1.val("");
                    node2.val("");
                    node1.nextAll("span").text(msg).css("color", "red");
                    return false;
                }
            },
            //用户名重复校验
            userNameAvailable: function (msg1, msg2) {
                let node = $("input[name='username']");
                if (node.val() === "")
                    // 如果没通过非空校验，直接返回false
                    return false;
                $.ajax({
                    "url": "${pageContext.request.contextPath}/AjaxUsernameServlet",
                    "data": {"username": node.val()},
                    "async": true,
                    "type": "POST",
                    "success": function (result) {
                        if (eval(result)) {
                            // 用户名可以使用
                            node.nextAll("span").text(msg1).css("color", "#00716d");
                        }else{
                            // 用户名不可以使用
                            node.nextAll("span").text(msg2).css("color", "red");
                        }
                    }
                });
            },
            // 表单前端校验
            checkForm: function () {
                let result = true;
                result = (!this.isNull("username", "用户名不能为空")) && result;
                result = (!this.isNull("password", "密码不能为空")) && result;
                result = (!this.isNull("password2", "确认密码不能为空")) && result;
                result = this.isEqual("password", "password2", "两次密码输入不一致") && result;
                result = (!this.isNull("nickname", "昵称不能为空")) && result;
                result = (!this.isNull("email", "邮箱不能为空")) && result;
                result = this.isRegexValid("email", /^\w+(\.\w+)*@\w+(\.\w+)+$/, "邮箱格式不正确") && result;
                result = (!this.isNull("valistr", "验证码不能为空")) && result;
                return result;
            }
        }
    </script>
</head>
<body>
<img src="${pageContext.request.contextPath}/img/login/logo.png" alt="logo" style="position: absolute;top: 8%;left: 12%;">
<form action="${pageContext.request.contextPath}/RegistServlet" method="POST" onsubmit="return formObj.checkForm();">
    <h1>欢迎注册网上商城</h1>
    <table>
        <tr>
            <td class="tds" colspan="2" style="color:red;text-align:center;">${requestScope.msg}</td>
        </tr>
        <tr>
            <td class="tds">用户名：</td>
            <td>
                <input type="text" name="username" value="${requestScope.username}"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td class="tds">密码：</td>
            <td>
                <input type="password" name="password" value="${requestScope.password}"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td class="tds">确认密码：</td>
            <td>
                <input type="password" name="password2" value="${requestScope.password2}"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td class="tds">昵称：</td>
            <td>
                <input type="text" name="nickname" value="${requestScope.nickname}"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td class="tds">邮箱：</td>
            <td>
                <input type="text" name="email" value="${requestScope.email}"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td class="tds">验证码：</td>
            <td>
                <input type="text" name="valistr"/>
                <img src="${pageContext.request.contextPath}/ValiImgServlet" width="" height="" alt="验证码" onclick="refreshValistr(this)"/>
                <span></span>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tds">
                <input type="submit" value="注册用户"/>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
