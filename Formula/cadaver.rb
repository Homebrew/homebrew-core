class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://directory.fsf.org/wiki/Cadaver"
  url "https://mirrorservice.org/sites/download.salixos.org/i486/extra-14.2/source/network/cadaver/cadaver-0.23.3.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cadaver/cadaver-0.23.3.tar.gz/502ecd601e467f8b16056d2acca39a6f/cadaver-0.23.3.tar.gz"
  mirror "https://web.archive.org/web/20170629224036/www.webdav.org/cadaver/cadaver-0.23.3.tar.gz"
  sha256 "fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca"
  revision 5

  bottle do
    sha256 "57ebca208464b812e3bbb1df71e68369227d29005a15c990087f7de761007458" => :mojave
    sha256 "d828c3a7454ea82ec5e575aebc3f57911ee3f08e45ed64ae1293026fc0ee8380" => :high_sierra
    sha256 "2a80f1355db0d31d395596ab4941565af8f3d6dda36952c834e2ebeaadb9d65b" => :sierra
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
+       for v in 27 28 29 30; do
           case $ne_libver in
           0.$v.*) ne_cv_lib_neonver=yes ;;
           esac
@@ -10975,8 +10975,8 @@
     fi
 
 else
-    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&5
-$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29" >&6;}
+    { $as_echo "$as_me:$LINENO: incompatible neon library version $ne_libver: wanted 0.27 28 29 30" >&5
+$as_echo "$as_me: incompatible neon library version $ne_libver: wanted 0.27 28 29 30" >&6;}
     neon_got_library=no
 fi
 
