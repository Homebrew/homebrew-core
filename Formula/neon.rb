class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.webdav.org/neon/neon-0.31.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.0.tar.gz"
  sha256 "80556f10830431476d1394c1f0af811f96109c4c4d119f0a9569b28c7526bda5"

  bottle do
    cellar :any
    sha256 "d87da64331ca21f48fa61b518e701654781008d46c5ca33840a34c41dda4a9e2" => :catalina
    sha256 "4c264a2164f7bb4f080a701b4fcc31c2bba54031ad574f25c33931abf7f205f0" => :mojave
    sha256 "96799d3568d37f8c2da6333d4bccaa23fa13e75d6ef1e75f993f18c53e525306" => :high_sierra
    sha256 "5f173cc83a291cb756046e94f09eb4031d5ec316988a757a6b5e2a92c310037d" => :sierra
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
