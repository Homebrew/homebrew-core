class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://directory.fsf.org/wiki/Cadaver"
  url "https://mirrorservice.org/sites/download.salixos.org/i486/extra-14.2/source/network/cadaver/cadaver-0.23.3.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/cadaver/cadaver-0.23.3.tar.gz/502ecd601e467f8b16056d2acca39a6f/cadaver-0.23.3.tar.gz"
  mirror "https://web.archive.org/web/20170629224036/www.webdav.org/cadaver/cadaver-0.23.3.tar.gz"
  sha256 "fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca"
  revision 3

  bottle do
    sha256 "91c567ec5f2d8b2ce2c0b78868a07ef9fa3340c8bdd651a59d21ee208d6bb49c" => :mojave
    sha256 "25a0e28cd5861306d85971db60a3f0e3141cf8506aa8def86fbdb5b2f5bc073a" => :high_sierra
    sha256 "a67a574144407776beb82dbe6ddafc74f426e2c159e144d1bddb9b30c0719892" => :sierra
    sha256 "33ea3e322fb91ce080693dfc11fc631eb4103a20c8b3b5eaa06dcc02d61a44bf" => :el_capitan
    sha256 "cbfcae8d96f1c55f58220c319cf75fb953abfc765c3eb76d3dfb3973fff8d343" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "neon"
  depends_on "openssl"
  depends_on "readline"

  # enable build with the latest neon
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl"].opt_prefix}",
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
 
