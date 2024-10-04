class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.5/libtirpc-1.3.5.tar.bz2"
  sha256 "9b31370e5a38d3391bf37edfa22498e28fe2142467ae6be7a17c9068ec0bf12f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "91acf8d2991b6c027d780f8662e81f154c6101d651fb80bf16db5e6d8ba0696f"
  end

  # the build depends are needed while we need to regenerate configure
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "krb5"
  patch :DATA # all patches were sent to libtirpc-devel during the 1.3.6 cycle

  def install
    # the autoreconf and environment overrides can go away when the patches
    # that are inlined here are accepted or otherwise implemented upstream
    ENV.append_path "ACLOCAL_PATH", "m4"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/rpc.h>
      #include <rpc/xdr.h>
      #include <stdio.h>

      int main() {
        XDR xdr;
        char buf[256];
        xdrmem_create(&xdr, buf, sizeof(buf), XDR_ENCODE);
        int i = 42;
        xdr_destroy(&xdr);
        printf("xdr_int succeeded");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 756c958..0217519 100644
--- a/configure.ac
+++ b/configure.ac
@@ -51,6 +51,14 @@ if test "x$enable_gssapi" = xyes; then
 	GSSAPI_LIBS=`${KRB5_CONFIG} --libs gssapi`
 	AC_SUBST([GSSAPI_CFLAGS])
 	AC_SUBST([GSSAPI_LIBS])
+
+	gssapi_save_CPPFLAGS="$CPPFLAGS"
+	gssapi_save_LIBS="$LIBS"
+	CPPFLAGS="$GSSAPI_CPPFLAGS $CPPFLAGS"
+	LIBS="$GSSAPI_LIBS $LIBS"
+	AC_CHECK_FUNCS([gss_pname_to_uid])
+	CPPFLAGS="$gssapi_save_CPPFLAGS"
+	LIBS="$gssapi_save_LIBS"
 fi
 
 AC_ARG_ENABLE(authdes,
@@ -71,7 +79,22 @@ fi
 
 AC_ARG_ENABLE(symvers,
 	[AC_HELP_STRING([--disable-symvers], [Disable symbol versioning @<:@default=no@:>@])],
-      [],[enable_symvers=yes])
+      [],[enable_symvers=maybe])
+
+if test "x$enable_symvers" = xmaybe; then
+   AC_MSG_CHECKING(if version scripts are supported)
+   check_vscript_save_flags="$LDFLAGS"
+   echo "V1 { global: show; local: *; };" > conftest.map
+   AS_IF([test x = xyes], [echo "{" >> conftest.map])
+   LDFLAGS="$LDFLAGS -Wl,--version-script,conftest.map"
+   AC_LINK_IFELSE([AC_LANG_PROGRAM([[int show, hide;]], [])], [
+   enable_symvers=yes
+   AC_MSG_RESULT(yes)
+   ], [AC_MSG_RESULT(no)])
+   LDFLAGS="$check_vscript_save_flags"
+   rm -f conftest.map
+fi
+
 AM_CONDITIONAL(SYMVERS, test "x$enable_symvers" = xyes)
 
 AC_CANONICAL_BUILD
@@ -89,14 +112,71 @@ case $build_os in
 esac
 
 
+AC_MSG_CHECKING(for SOL_IP)
+AC_TRY_COMPILE([#include <netdb.h>], [
+	int ipproto = SOL_IP;
+], [
+	AC_MSG_RESULT(yes)
+	AC_DEFINE(HAVE_SOL_IP, 1, [Have SOL_IP])
+], [
+	AC_MSG_RESULT(no)
+])
+
+AC_MSG_CHECKING(for SOL_IPV6)
+AC_TRY_COMPILE([#include <netdb.h>], [
+	int ipproto = SOL_IPV6;
+], [
+	AC_MSG_RESULT(yes)
+	AC_DEFINE(HAVE_SOL_IPV6, 1, [Have SOL_IPV6])
+], [
+	AC_MSG_RESULT(no)
+])
+
+AC_MSG_CHECKING(for IPPROTO_IP)
+AC_TRY_COMPILE([#include <netinet/in.h>], [
+	int ipproto = IPPROTO_IP;
+], [
+	AC_MSG_RESULT(yes)
+	AC_DEFINE(HAVE_IPPROTO_IP, 1, [Have IPPROTO_IP])
+], [
+	AC_MSG_RESULT(no)
+])
+
+AC_MSG_CHECKING(for IPPROTO_IPV6)
+AC_TRY_COMPILE([#include <netinet/in.h>], [
+	int ipproto = IPPROTO_IPV6;
+], [
+	AC_MSG_RESULT(yes)
+	AC_DEFINE(HAVE_IPPROTO_IPV6, 1, [Have IPPROTO_IPV6])
+], [
+	AC_MSG_RESULT(no)
+])
+AC_MSG_CHECKING([for IPV6_PKTINFO])
+AC_TRY_COMPILE([#include <netdb.h>], [
+  int opt = IPV6_PKTINFO;
+], [
+  AC_MSG_RESULT([yes])
+], [
+AC_TRY_COMPILE([#define __APPLE_USE_RFC_3542
+			#include <netdb.h>], [
+  int opt = IPV6_PKTINFO;
+], [
+  AC_MSG_RESULT([yes with __APPLE_USE_RFC_3542])
+  AC_DEFINE([__APPLE_USE_RFC_3542], [1], [show IPV6_PKTINFO internals on macos])
+], [
+  AC_MSG_RESULT([no])
+])
+])
+
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_LIBTOOL
 AC_HEADER_DIRENT
 AC_PREFIX_DEFAULT(/usr)
-AC_CHECK_HEADERS([arpa/inet.h fcntl.h libintl.h limits.h locale.h netdb.h netinet/in.h stddef.h stdint.h stdlib.h string.h sys/ioctl.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h features.h gssapi/gssapi_ext.h])
+AC_CHECK_HEADERS([arpa/inet.h fcntl.h libintl.h limits.h locale.h netdb.h netinet/in.h stddef.h stdint.h stdlib.h string.h sys/ioctl.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h features.h gssapi/gssapi_ext.h endian.h machine/endian.h])
 AX_PTHREAD
-AC_CHECK_FUNCS([getrpcbyname getrpcbynumber setrpcent endrpcent getrpcent])
-
+AC_CHECK_FUNCS([getpeereid getrpcbyname getrpcbynumber setrpcent endrpcent getrpcent])
+AC_CHECK_TYPES(struct rpcent,,, [
+      #include <netdb.h>])
 AC_CONFIG_FILES([Makefile src/Makefile man/Makefile doc/Makefile])
 AC_OUTPUT(libtirpc.pc)
 
diff --git a/src/getpeereid.c b/src/getpeereid.c
index dd85270..e1e551b 100644
--- a/src/getpeereid.c
+++ b/src/getpeereid.c
@@ -24,6 +24,9 @@
  * SUCH DAMAGE.
  */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
 
 #include <sys/param.h>
 #include <sys/socket.h>
@@ -32,6 +35,8 @@
 #include <errno.h>
 #include <unistd.h>
 
+#if !HAVE_GETPEEREID
+
 int
 getpeereid(int s, uid_t *euid, gid_t *egid)
 {
@@ -49,3 +54,5 @@ getpeereid(int s, uid_t *euid, gid_t *egid)
 	*egid = uc.gid;
 	return (0);
  }
+
+#endif
diff --git a/src/rpc_com.h b/src/rpc_com.h
index ded72d1..7551016 100644
--- a/src/rpc_com.h
+++ b/src/rpc_com.h
@@ -46,6 +46,18 @@
 extern "C" {
 #endif
 
+#ifndef SOL_IPV6
+  #ifdef IPPROTO_IPV6
+  #define SOL_IPV6 IPPROTO_IPV6
+  #endif
+#endif
+
+#ifndef SOL_IP
+  #ifdef IPPROTO_IP
+  #define SOL_IP IPPROTO_IP
+  #endif
+#endif
+
 struct netbuf *__rpc_set_netbuf(struct netbuf *, const void *, size_t);
 
 struct netbuf *__rpcb_findaddr_timed(rpcprog_t, rpcvers_t,
diff --git a/src/svc_auth_gss.c b/src/svc_auth_gss.c
index bece46a..20b36d5 100644
--- a/src/svc_auth_gss.c
+++ b/src/svc_auth_gss.c
@@ -990,8 +990,12 @@ _rpc_gss_fill_in_ucreds(struct svc_rpc_gss_data *gd)
 	ucred->gidlen = 0;
 	ucred->gidlist = gd->gids;
 
+#ifdef HAVE_GSS_PNAME_TO_UID
 	maj_stat = gss_pname_to_uid(&min_stat, gd->client_name,
 						gd->sec.mech, &uid);
+#else
+	maj_stat = GSS_S_FAILURE;
+#endif
 	if (maj_stat != GSS_S_COMPLETE)
 		return;
 
diff --git a/src/svc_dg.c b/src/svc_dg.c
index a9f63ff..7677cb3 100644
--- a/src/svc_dg.c
+++ b/src/svc_dg.c
@@ -37,6 +37,9 @@
  *
  * Does some caching in the hopes of achieving execute-at-most-once semantics.
  */
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
 #include <pthread.h>
 #include <reentrant.h>
 #include <sys/types.h>
diff --git a/src/svc_raw.c b/src/svc_raw.c
index a8a396f..1f0bf97 100644
--- a/src/svc_raw.c
+++ b/src/svc_raw.c
@@ -43,6 +43,9 @@
 #include <sys/types.h>
 #include <rpc/raw.h>
 #include <stdlib.h>
+#ifdef HAVE_STRING_H
+#include <string.h>
+#endif
 
 #ifndef UDPMSGSIZE
 #define	UDPMSGSIZE 8800
diff --git a/src/xdr_float.c b/src/xdr_float.c
index 349d48f..c86d516 100644
--- a/src/xdr_float.c
+++ b/src/xdr_float.c
@@ -83,7 +83,13 @@ static struct sgl_limits {
 };
 #else
 
+#ifdef HAVE_ENDIAN_H
 #include <endian.h>
+#else
+#ifdef HAVE_MACHINE_ENDIAN_H
+#include <machine/endian.h>
+#endif
+#endif
 #define IEEEFP
 
 #endif /* vax */
diff --git a/tirpc/reentrant.h b/tirpc/reentrant.h
index 5bb581a..5b48ef3 100644
--- a/tirpc/reentrant.h
+++ b/tirpc/reentrant.h
@@ -36,7 +36,7 @@
  * These definitions are only guaranteed to be valid on Linux. 
  */
 
-#if defined(__linux__)
+#if defined(__linux__) || defined(__APPLE__)
 
 #include <pthread.h>
 
diff --git a/tirpc/rpc/rpcent.h b/tirpc/rpc/rpcent.h
index 5bff876..e2fcfe8 100644
--- a/tirpc/rpc/rpcent.h
+++ b/tirpc/rpc/rpcent.h
@@ -50,7 +50,7 @@ extern "C" {
 
 /* These are defined in /usr/include/rpc/netdb.h, unless we are using
    the C library without RPC support. */
-#if defined(__UCLIBC__) && !defined(__UCLIBC_HAS_RPC__) || !defined(__GLIBC__)
+#if defined(__UCLIBC__) && !defined(__UCLIBC_HAS_RPC__) || !defined(__GLIBC__) && !defined(HAVE_STRUCT_RPCENT)
 struct rpcent {
 	char	*r_name;	/* name of server for this rpc program */
 	char	**r_aliases;	/* alias list */
