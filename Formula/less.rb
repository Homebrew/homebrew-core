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
    rebuild 1
    sha256 "0484ddddfc2032fd649e13fc85e70fb324aaf274e77a64460c6461ca8b15dc3e" => :big_sur
    sha256 "256e333b35fc588aabec222e12e21141cc75d10dd0171ccd6e8915ba84efc8db" => :catalina
    sha256 "5f44d9a8cd58bc98f833fbac17be5fcfb8057b63f33abffb7e7d4cff58be2d17" => :mojave
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
