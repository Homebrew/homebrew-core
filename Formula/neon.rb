class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.2.tar.gz"
  sha256 "986566468c6295fc5d0fb141a5981e31c9f82ee38e938374abed8471ef2fb286"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b10f6c1be6a6897763339f92831344a2ca97a27e26bc8c27399358f6214961f"
    sha256 cellar: :any,                 arm64_big_sur:  "c3e6c0140a0761348ec6ebb26ff464bc3baf250b3674df7a9692a0af7a6d4068"
    sha256 cellar: :any,                 monterey:       "2a3ce9b7329c7abcbbe9167e8d5fef45a242d1ae2d876a989b41cabbec19171a"
    sha256 cellar: :any,                 big_sur:        "ddf63fc6da79aa76871cf66c88237c2a0cb83a35fd01263c608c9c8dbf122ff7"
    sha256 cellar: :any,                 catalina:       "25216dfe96706b6e1cab7cc6b15300571fe38a00973e0c31209886a1005cf290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9929c188b7c2bac00ea1bbb3b169481e02feb41d04157b80ba19b47e78b9add7"
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
