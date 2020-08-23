class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.31.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.2.tar.gz"
  sha256 "cf1ee3ac27a215814a9c80803fcee4f0ede8466ebead40267a9bd115e16a8678"

  bottle do
    cellar :any
    sha256 "4cb9cac535f8d40ca71c0bb04fe2baa24f929685d06caf71311d285933ac0828" => :catalina
    sha256 "3aef45d339688bda9dd7dc6682bebb97f8c0eb349a0ebb9a92d92e01635a5f75" => :mojave
    sha256 "e1a66cf7af9daade4ce304c14b11b797610f448f194306e996ffacab04c2af5d" => :high_sierra
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
