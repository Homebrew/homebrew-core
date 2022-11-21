class Alpine < Formula
  desc "News and email agent"
  homepage "https://alpineapp.email"
  url "https://alpineapp.email/alpine/release/src/alpine-2.26.tar.xz"
  # keep mirror even though `brew audit --strict --online` complains
  mirror "https://alpineapp.email/alpine/release/src/Old/alpine-2.26.tar.xz"
  sha256 "c0779c2be6c47d30554854a3e14ef5e36539502b331068851329275898a9baba"
  license "Apache-2.0"
  head "https://repo.or.cz/alpine.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9515f6ff399dfc1ce8c44d8aa69f8ae964b9a49f286a305b80f503330feaa700"
    sha256 arm64_monterey: "73c032d1c64a658eb8de39c13cc9d5ac1c0094649414b01986ca6904a99e34a4"
    sha256 arm64_big_sur:  "0eec06860d16e03d7b2c658b52999ac43a4a5b1c89899303a3a6e8c536059cfc"
    sha256 ventura:        "690b598885d6f5a920ef48620f0c5dcdf667ae681dfa375dce86c7c5e22623f3"
    sha256 monterey:       "6cafdbf3f332fc0f2fe3b3e1b604b1092afa426d4c93fff99b5a81de0e542618"
    sha256 big_sur:        "14e22faaa2ba81fcd8abdea1e9e2f132ac3707fd62db654460ee17228062e3ab"
    sha256 catalina:       "a42365580afd59810fb4cd1a36eae5a71a79c98cee667df38e0a8ee6ad6ce01d"
    sha256 x86_64_linux:   "2f42ad074087b105bd2c0fe4e491374d4dc962d3ebe028ec1d54570e6c80fcd2"
  end

  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_linux do
    depends_on "linux-pam"
  end

  # patch for macOS obtained from developer; see git commit
  # https://repo.or.cz/alpine.git/commitdiff/701aebc00aff0585ce6c96653714e4ba94834c9c
  patch :DATA

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@3
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -18752,6 +18752,26 @@
 fi
 
 
+
+# Check whether --with-local-password-cache was given.
+if test "${with_local_password_cache+set}" = set; then :
+  withval=$with_local_password_cache;
+     alpine_os_credential_cache=$withval
+
+fi
+
+
+
+# Check whether --with-local-password-cache-method was given.
+if test "${with_local_password_cache_method+set}" = set; then :
+  withval=$with_local_password_cache_method;
+     alpine_os_credential_cache_method=$withval
+
+fi
+
+
+alpine_cache_os_method="no"
+
 alpine_PAM="none"
 
 case "$host" in
@@ -18874,6 +18894,7 @@
 
 $as_echo "#define APPLEKEYCHAIN 1" >>confdefs.h
 
+	alpine_cache_os_method="yes"
 	;;
     esac
     if test -z "$alpine_c_client_bundled" ; then
@@ -19096,25 +19117,7 @@
 
 
 
-
-# Check whether --with-local-password-cache was given.
-if test "${with_local_password_cache+set}" = set; then :
-  withval=$with_local_password_cache;
-     alpine_os_credential_cache=$withval
-
-fi
-
-
-
-# Check whether --with-local-password-cache-method was given.
-if test "${with_local_password_cache_method+set}" = set; then :
-  withval=$with_local_password_cache_method;
-     alpine_os_credential_cache_method=$withval
-
-fi
-
-
-if test -z "$alpine_PASSFILE" ; then
+if test -z "$alpine_PASSFILE" -a "alpine_cache_os_method" = "no" ; then
   if test -z "$alpine_SYSTEM_PASSFILE" ; then
      alpine_PASSFILE=".alpine.pwd"
   else
@@ -25365,4 +25368,3 @@
   { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: unrecognized options: $ac_unrecognized_opts" >&5
 $as_echo "$as_me: WARNING: unrecognized options: $ac_unrecognized_opts" >&2;}
 fi
-
