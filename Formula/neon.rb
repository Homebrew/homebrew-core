class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.31.1.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.1.tar.gz"
  sha256 "c9dfcee723050df37ce18ba449d7707b78e7ab8230f3a4c59d9112e17dc2718d"

  bottle do
    cellar :any
    sha256 "2e2ef2abe3ecc7665a45c17e94a2f164e9d3c08e278d1d62ca2d322b5768d9c5" => :catalina
    sha256 "b457ca7dbc51c2eeccc0d13bdb724bbc49b84c3b56803b044342b68b3bfd39a6" => :mojave
    sha256 "38e7be8f574a6bc0a7d5a275a1181f80a62441a8bf811a410c7ca1795bce60d6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }

 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
