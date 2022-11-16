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
    sha256 cellar: :any,                 arm64_ventura:  "a9fd781dc1834be9e1066f51793ba4f377d33a085ec777a2f657968e2b61d77d"
    sha256 cellar: :any,                 arm64_monterey: "8a9d15eed842a8cde2a71a19b3fc2fae4e29213c1d356c568383350bfde14f25"
    sha256 cellar: :any,                 arm64_big_sur:  "421c1b74a8a1d8a60d64d839d483914e65d93d1c2005d5642aac81d0dad715ff"
    sha256 cellar: :any,                 ventura:        "403ffe3d4e963180933120bd279e5c6a17612794e56713b8e18a254ab26cdd4c"
    sha256 cellar: :any,                 monterey:       "b480974e79ffe9f828b0cc7068db7d336a2eef8ad311ef4e3e70f08aa95ec601"
    sha256 cellar: :any,                 big_sur:        "a06568dabaf8ebac45d53833a5bfb558aac0f97e07014fd80fe3ecb28dbff780"
    sha256 cellar: :any,                 catalina:       "8bdcc4e6be196c4cffccee3d185154094c7938ffc40a37f43394a58b5770e113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef06a3735703c5e37bdf6973045db324a21719af799c1e92809fcfb6bafe5c1"
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
