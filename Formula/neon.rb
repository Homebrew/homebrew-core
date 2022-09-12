class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.4.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.4.tar.gz"
  sha256 "b1e2120e4ae07df952c4a858731619733115c5f438965de4fab41d6bf7e7a508"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c4618e2d78ae5d4c3884a5a59131eeb309d1884ba41e376c044328510976d0f"
    sha256 cellar: :any,                 arm64_big_sur:  "dcdc765d8760cecc458d9e64ca8562f498d969b5ea52b9f45c1f1504a705c1fd"
    sha256 cellar: :any,                 monterey:       "f3142a2ae903721694aae7fdeca055b6e4707ba0897858fd73d9c28ee75c9997"
    sha256 cellar: :any,                 big_sur:        "1456e9957c3225719f6662bb2e9bd504ee7c38b3932f51abae6979875426c005"
    sha256 cellar: :any,                 catalina:       "42e300e95e79b35251518d7594484202c65b3684a18ef4bbb48698767dad9e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a533220d0ac093155f0e0ff32e246fb4fb0d3c87aa33857be8048e1a4a8f72"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

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
