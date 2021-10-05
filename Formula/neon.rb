class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.1.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.1.tar.gz"
  sha256 "05c54bc115030c89e463a4fb28d3a3f8215879528ba5ca70d676d3d21bf3af52"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "86e0ca2c11f4882900d48f5c6c87f29ed437c0fd4c311d06174c9bd10ef3542c"
    sha256 cellar: :any,                 big_sur:       "86819110b5eacedd6be7e53d202b532c4b956062217685ae98bb96e547ad58cd"
    sha256 cellar: :any,                 catalina:      "f5385868f91943383ca9674f2589280e30b55f4156086db05efa160411738467"
    sha256 cellar: :any,                 mojave:        "de9f23227aac7ec30b4a412d783e5dfdb788a51c51e66689f01705207270805e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b5a9528950d32639c71726cd22bf01e6dc9df7dea38d4dccc17ab7844798a7"
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
