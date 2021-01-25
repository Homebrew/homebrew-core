class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  license "GPL-3.0-or-later"

  stable do
    url "http://www.greenwoodsoftware.com/less/less-563.tar.gz"
    sha256 "ce5b6d2b9fc4442d7a07c93ab128d2dff2ce09a1d4f2d055b95cf28dd0dc9a9a"

    # Fix build with Xcode 12 as it no longer allows implicit function declarations
    # See https://github.com/gwsw/less/issues/91
    patch :DATA
  end

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+).+?released.+?general use/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "431d227c11a0d52bb4d4392244615933d9f04265f36faedc93f5406226d38076" => :big_sur
    sha256 "c7bc35b8debbb322fc3bdd644ba526eeec3ab8d5f982c76442995a763c77c739" => :arm64_big_sur
    sha256 "491fc7dc78848cd91c85c4a6a1ff5457166c0ad83dda9f05145489c2aa2828eb" => :catalina
    sha256 "d03e895349d8503cea9c8da326015298bf64d80796ab9ee62138a4a072e4559f" => :mojave
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  def install
    system "make", "-f", "Makefile.aut", "dist" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
__END__
diff --git a/configure b/configure
index 0ce6db1..eac7ca0 100755
--- a/configure
+++ b/configure
@@ -4104,11 +4104,11 @@ if test "x$TERMLIBS" = x; then
     TERMLIBS="-lncurses"
     SAVE_LIBS=$LIBS
     LIBS="$LIBS $TERMLIBS"
     cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
-
+#include <termcap.h>
 int
 main ()
 {
 tgetent(0,0); tgetflag(0); tgetnum(0); tgetstr(0,0);
   ;
