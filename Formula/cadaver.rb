class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://directory.fsf.org/wiki/Cadaver"
  url "https://mirrorservice.org/sites/download.salixos.org/i486/extra-14.2/source/network/cadaver/cadaver-0.23.3.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cadaver/cadaver-0.23.3.tar.gz/502ecd601e467f8b16056d2acca39a6f/cadaver-0.23.3.tar.gz"
  mirror "https://web.archive.org/web/20170629224036/www.webdav.org/cadaver/cadaver-0.23.3.tar.gz"
  sha256 "fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca"
  license "GPL-2.0-or-later"
  revision 5
  head "https://github.com/notroj/cadaver.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f31ec5eb5056e09d4b8a22a2323fb2bbe3c8c15ea89be69429382c00ec534d3c"
    sha256 arm64_monterey: "4ffec4d1167cb17f80cb63c4142909b6f208cc653518cee7f46fb7c1f270e192"
    sha256 arm64_big_sur:  "859215276f7fda671ceee3b7908772d84fccd12873e6bb6cac0f90c50982cbcc"
    sha256 ventura:        "276617de9ff7b225421e56658cba86766a180a42f6458586b7e0903be7945c2e"
    sha256 monterey:       "72eea3f287da7f77740b72db463cdf967c355a4044d0730150d637145d6be312"
    sha256 big_sur:        "240a41ea5b71aa144bea0fdb28b6233130d5368e8a221171eaa7bee24f5075a6"
    sha256 catalina:       "da94dea10afd90e1d0e41f24d4319ea006bf909381de2c2379c3144374c3feff"
    sha256 mojave:         "a232491b47135718f6cf65d00954099d92a43f5fcc6b01838a676faa77f2ed13"
    sha256 x86_64_linux:   "03a8734a293f551585c100ce10389aa2a66222ab711d9c80b7300d139eb8546b"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "neon"
  depends_on "openssl@1.1"
  depends_on "readline"

  # enable build with the latest neon
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-neon=#{Formula["neon"].opt_prefix}"
    system "make", "-C", "lib/intl"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end

__END__
--- cadaver-0.23.3-orig/configure	2009-12-16 01:36:26.000000000 +0300
+++ cadaver-0.23.3/configure	2013-11-04 22:44:00.000000000 +0400
@@ -10328,7 +10328,7 @@
 $as_echo "$ne_cv_lib_neon" >&6; }
     if test "$ne_cv_lib_neon" = "yes"; then
        ne_cv_lib_neonver=no
-       for v in 27 28 29; do
+       for v in 27 28 29 30 31 32; do
           case $ne_libver in
           0.$v.*) ne_cv_lib_neonver=yes ;;
           esac
@@ -10975,8 +10975,8 @@
     fi
 
 else
-    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&5
-$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&6;}
+    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29 30 31 32" >&5
+$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29 30 31 32" >&6;}
     neon_got_library=no
 fi
 
