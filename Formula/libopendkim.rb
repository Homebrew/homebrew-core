class Libopendkim < Formula
  desc "Implementation of Domain Keys Identified Mail authentication"
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.10.3.tar.gz"
  sha256 "43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b"
  revision 2

  bottle do
    cellar :any
    sha256 "76268e02f90b0931a9fd8d2ae933d334c2efb9ee34dc85c77d8eecc25b48c68b" => :mojave
    sha256 "e5d79e2cd539dff2a02ac91b171b23c0c36d7d012d2a3d21af1cbd732c2ee58a" => :high_sierra
    sha256 "33a66999fc2479cd6d0d27d2189ed34125e2510afb7afe0c97cdb08ed67efc95" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "unbound"

  # Patch for compatibility with OpenSSL 1.1.1
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=223568
  patch :p0, :DATA

  def install
    # Recreate configure due to patch
    system "autoreconf", "-fvi"

    # --disable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula["unbound"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/opendkim-genkey", "--directory=#{testpath}"
    assert_predicate testpath/"default.private", :exist?
    assert_predicate testpath/"default.txt", :exist?
  end
end
__END__
--- libopendkim/tests/Makefile.in.orig	2015-05-12 18:43:48 UTC
+++ libopendkim/tests/Makefile.in
@@ -1108,8 +1108,10 @@ am__nobase_list = $(am__nobase_strip_setup); \
       { print $$2, files[$$2]; n[$$2] = 0; files[$$2] = "" } } \
     END { for (dir in files) print dir, files[dir] }'
 am__base_list = \
-  sed '$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;s/\n/ /g' | \
-  sed '$$!N;$$!N;$$!N;$$!N;s/\n/ /g'
+  sed '$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;s/\
+/ /g' | \
+  sed '$$!N;$$!N;$$!N;$$!N;s/\
+/ /g'
 am__uninstall_files_from_dir = { \
   test -z "$$files" \
     || { test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; } \
@@ -4131,16 +4133,19 @@ uninstall-am: uninstall-dist_docDATA
 @LCOV_TRUE@description.txt: $(check_PROGRAMS) $(check_SCRIPTS)
 @LCOV_TRUE@	rm -f $@
 @LCOV_TRUE@	for i in $(check_PROGRAMS); do \
-@LCOV_TRUE@		testname=$${i/t-}; \
-@LCOV_TRUE@		testname=$${testname//-/_}; \
+@LCOV_TRUE@		testname=$${i#t-}; \
+@LCOV_TRUE@		testname=$$(echo $${testname} | sed -e 's/-/_/g'); \
 @LCOV_TRUE@		fgrep '***' $$i.c | tail -n 1 | \
-@LCOV_TRUE@		(echo $${testname} ; sed -e 's/[^*]*\*\*\*\(.*\)\\n.*/\t\1\n/g' ) >> $@; \
+@LCOV_TRUE@		(echo $${testname} ; sed -e 's/[^*]*\*\*\*\(.*\)\\
+@LCOV_TRUE@.*/	\1\
+@LCOV_TRUE@/g' ) >> $@; \
 @LCOV_TRUE@	done
 @LCOV_TRUE@	for i in $(check_SCRIPTS); do \
-@LCOV_TRUE@		testname=$${i/t-}; \
-@LCOV_TRUE@		testname=$${testname//-/_}; \
+@LCOV_TRUE@		testname=$${i#t-}; \
+@LCOV_TRUE@		testname=$$(echo $${testname} | sed -e 's/-/_/g'); \
 @LCOV_TRUE@		grep '^#' $$i | tail -n 1 | \
-@LCOV_TRUE@		(echo $${testname} ; sed -e 's/^# \(.*\)/\t\1\n/g' ) >> $@; \
+@LCOV_TRUE@		(echo $${testname} ; sed -e 's/^# \(.*\)/	\1\
+@LCOV_TRUE@/g' ) >> $@; \
 @LCOV_TRUE@	done

 @LCOV_TRUE@description.html: description.txt
--- libopendkim/dkim-canon.c.orig	2015-05-11 03:56:13 UTC
+++ libopendkim/dkim-canon.c
@@ -388,7 +388,7 @@ dkim_canon_header_string(struct dkim_dstring *dstr, dk
		}

		/* skip all spaces before first word */
-		while (*p != '\0' && DKIM_ISWSP(*p))
+		while (*p != '\0' && DKIM_ISLWSP(*p))
			p++;

		space = FALSE;				/* just saw a space */
--- opendkim/tests/Makefile.in.orig	2015-05-12 18:43:49 UTC
+++ opendkim/tests/Makefile.in
@@ -139,8 +139,10 @@ am__nobase_list = $(am__nobase_strip_setup); \
       { print $$2, files[$$2]; n[$$2] = 0; files[$$2] = "" } } \
     END { for (dir in files) print dir, files[dir] }'
 am__base_list = \
-  sed '$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;s/\n/ /g' | \
-  sed '$$!N;$$!N;$$!N;$$!N;s/\n/ /g'
+  sed '$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;$$!N;s/\
+/ /g' | \
+  sed '$$!N;$$!N;$$!N;$$!N;s/\
+/ /g'
 am__uninstall_files_from_dir = { \
   test -z "$$files" \
     || { test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; } \
@@ -1298,14 +1300,16 @@ uninstall-am: uninstall-dist_docDATA
 @LCOV_TRUE@description.txt: $(check_SCRIPTS)
 @LCOV_TRUE@	rm -f $@
 @LCOV_TRUE@	for test in $? ; do \
-@LCOV_TRUE@		testname=$${test/t-}; \
-@LCOV_TRUE@		testname=$${testname//-/_}; \
+@LCOV_TRUE@		testname=$${test#t-}; \
+@LCOV_TRUE@		testname=$$(echo $${testname} | sed -e 's/-/_/g'); \
 @LCOV_TRUE@		grep ^# $$test | tail -n 1 | \
-@LCOV_TRUE@			sed -e "s/^#\(.*\)/$${testname}\n\t\1\n/g" >> $@; \
+@LCOV_TRUE@			sed -e "s/^#\(.*\)/$${testname}\
+@LCOV_TRUE@	\1\
+@LCOV_TRUE@/g" >> $@; \
 @LCOV_TRUE@	done

 @LCOV_TRUE@description.html: description.txt
-@LCOV_TRUE@	gendesc --output $@ $<
+@LCOV_TRUE@	gendesc --output $@ $?

 @LCOV_TRUE@maintainer-clean-local:
 @LCOV_TRUE@	-rm -rf lcov/[^C]*
--- opendkim/opendkim-crypto.c.orig	2013-02-25 21:02:41 UTC
+++ opendkim/opendkim-crypto.c
@@ -222,7 +222,11 @@ dkimf_crypto_free_id(void *ptr)
	{
		assert(pthread_setspecific(id_key, ptr) == 0);

+#if (OPENSSL_VERSION_NUMBER >= 0x10100000 && !defined(LIBRESSL_VERSION_NUMBER))
+		OPENSSL_thread_stop();
+#else
		ERR_remove_state(0);
+#endif

		free(ptr);

@@ -392,11 +396,15 @@ dkimf_crypto_free(void)
 {
	if (crypto_init_done)
	{
+#if (OPENSSL_VERSION_NUMBER >= 0x10100000 && !defined(LIBRESSL_VERSION_NUMBER))
+		OPENSSL_thread_stop();
+#else
		CRYPTO_cleanup_all_ex_data();
		CONF_modules_free();
		EVP_cleanup();
		ERR_free_strings();
		ERR_remove_state(0);
+#endif

		if (nmutexes > 0)
		{
--- configure.ac.orig	2015-05-12 18:43:09 UTC
+++ configure.ac
@@ -860,26 +860,28 @@ then
	AC_SEARCH_LIBS([ERR_peek_error], [crypto], ,
	               AC_MSG_ERROR([libcrypto not found]))

-	AC_SEARCH_LIBS([SSL_library_init], [ssl], ,
-		[
-			if test x"$enable_shared" = x"yes"
-			then
-				AC_MSG_ERROR([Cannot build shared opendkim
-				              against static openssl libraries.
-				              Configure with --disable-shared
-				              to get this working or obtain a
-				              shared libssl library for
-				              opendkim to use.])
-			fi

-			# avoid caching issue - last result of SSL_library_init
-			# shouldn't be cached for this next check
-			unset ac_cv_search_SSL_library_init
-			LIBCRYPTO_LIBS="$LIBCRYPTO_LIBS -ldl"
-			AC_SEARCH_LIBS([SSL_library_init], [ssl], ,
-			               AC_MSG_ERROR([libssl not found]), [-ldl])
-		]
-	)
+	AC_LINK_IFELSE(
+		       [AC_LANG_PROGRAM([[#include <openssl/ssl.h>]],
+					[[SSL_library_init();]])],
+					[od_have_ossl="yes";],
+					[od_have_ossl="no";])
+	if test x"$od_have_ossl" = x"no"
+	then
+		if test x"$enable_shared" = x"yes"
+		then
+			AC_MSG_ERROR([Cannot build shared opendkim
+			              against static openssl libraries.
+			              Configure with --disable-shared
+			              to get this working or obtain a
+			              shared libssl library for
+			              opendkim to use.])
+		fi
+
+		LIBCRYPTO_LIBS="$LIBCRYPTO_LIBS -ldl"
+		AC_SEARCH_LIBS([SSL_library_init], [ssl], ,
+		               AC_MSG_ERROR([libssl not found]), [-ldl])
+	fi

	AC_CHECK_DECL([SHA256_DIGEST_LENGTH],
                       AC_DEFINE([HAVE_SHA256], 1,
