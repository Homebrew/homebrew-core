class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://www.greenwoodsoftware.com/less/less-563.tar.gz"
  sha256 "ce5b6d2b9fc4442d7a07c93ab128d2dff2ce09a1d4f2d055b95cf28dd0dc9a9a"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+).+?released.+?general use/i)
  end

  bottle do
    cellar :any
    sha256 "a76b3f1fb43e1e0ab566a70eca5430afa744d6d87430b55e9a5b98160834c8b9" => :catalina
    sha256 "2ee3f16d15855ab88ad87067085c0f2dd58c90c5b91ae51499ae0548a24693b2" => :mojave
    sha256 "46cd5ba33b6a1d00cfa3993712ea617bce5b6c9908b016a72413f370eda714be" => :high_sierra
  end

  depends_on "pcre"

  uses_from_macos "ncurses"

  # Fix build with Xcode 12 as it no longer allows implicit function declarations
  # See https://github.com/gwsw/less/issues/91
  patch :DATA

  def install
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
