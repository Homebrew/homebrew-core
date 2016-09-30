class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "http://paps.sourceforge.net/"
  url "https://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz"
  sha256 "db214c4ea7ecde2f7986b869f6249864d3ff364e6f210c15aa2824bcbd850a20"

  bottle do
    cellar :any
    sha256 "9b8374465264e2d04873a198109bb802c76e2d5ddc9a21ae54c87c326977c9aa" => :sierra
    sha256 "eed9fb9ffec9f551d0d7fcb7692c2de9192d9eb0a34908559cae41d73fa30c25" => :el_capitan
    sha256 "c173071e5f66f0d911b8e8900ce9d6941cb0cbfed7fe5e1ffe623ec7c8c64e0c" => :yosemite
    sha256 "3e0b3b9b5591c1ee670dde1560d7339fbd1c05a47d51362aa78be0de1d671f08" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "gettext"

  # Find freetype headers
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # http://paps.sourceforge.net/small-hello.utf8
    utf8 = <<-EOS
paps by Dov Grobgeld (דב גרובגלד)
Printing through Παν語 (Pango)

Arabic السلام عليكم
Bengali (বাঙ্লা)  ষাগতোম
Greek (Ελληνικά)  Γειά σας
Hebrew שָׁלוֹם
Japanese  (日本語) こんにちは, ｺﾝﾆﾁﾊ
Chinese  (中文,普通话,汉语) 你好
Vietnamese  (Tiếng Việt)  Xin Chào
    EOS
    safe_system "echo '#{utf8}' |  #{bin}/paps > paps.ps"
  end
end

__END__
diff --git a/src/libpaps.c b/src/libpaps.c
index 6081d0d..d502b68 100644
--- a/src/libpaps.c
+++ b/src/libpaps.c
@@ -25,8 +25,10 @@
 
 #include <pango/pango.h>
 #include <pango/pangoft2.h>
-#include <freetype/ftglyph.h>
-#include <freetype/ftoutln.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
+#include FT_GLYPH_H
+#include FT_OUTLINE_H
 #include <errno.h>
 #include <stdlib.h>
 #include <stdio.h>
