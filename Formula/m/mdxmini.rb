class Mdxmini < Formula
  desc "Plays music in X68000 MDX chiptune format"
  homepage "https://github.com/mistydemeo/mdxmini/"
  url "https://github.com/mistydemeo/mdxmini/archive/v2.0.0.tar.gz"
  sha256 "9b623b365e893a769084f7a2effedc9ece453c6e3861c571ba503f045471a0e0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01720e2bc4f1207ec29261562b312955d96ceda87dc354ac708b8ff4f1b95565"
    sha256 cellar: :any,                 arm64_monterey: "703bdc526a902d8cb2190cbe385078bc5618952697ce3e6554a3473a9f1ec67c"
    sha256 cellar: :any,                 arm64_big_sur:  "0015ac050eb60388f47d9d8ad4dbc839be6c94c53896d472db1f902710d27504"
    sha256 cellar: :any,                 ventura:        "bc43ab7d3a985f855e1e2b266956ba2d50d394c73d55f5265fb8e2511b25c83f"
    sha256 cellar: :any,                 monterey:       "5e384c41501dd14903efefe829b14beb5db30d76bea9f0265aa957ed602fd400"
    sha256 cellar: :any,                 big_sur:        "4516c7fdc7b008d5d1c1447c8dd18c3562edb70619d40c8798933022da471794"
    sha256 cellar: :any,                 catalina:       "b3c9c8caa3da6169fedd4893e27d4156b016715fcbf91c47209c34ec4b536a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152c18564d3252af6530331c08788108b99fbac328066ace0c58f94428fe7b4e"
  end

  depends_on "sdl2"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/MDX/-%20unknown/Popful%20Mail/pop-00.mdx"
    sha256 "86f21fbbaf93eb60e79fa07c759b906a782afe4e1db5c7e77a1640e6bf63fd14"
  end

  # Fix build on Linux
  patch :DATA

  def install
    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cc}"

    # Makefile doesn't build a dylib
    libmdxmini = shared_library("libmdxmini")

    flags = if OS.mac?
      %W[
        -dynamiclib
        -install_name #{lib/libmdxmini}
        -undefined dynamic_lookup
      ]
    else
      ["-shared"]
    end

    system ENV.cc, *flags, "-o", libmdxmini, *Dir["obj/*.o"]

    bin.install "mdxplay"
    lib.install libmdxmini
    (include/"libmdxmini").install Dir["src/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"mdxtest.c").write <<~EOS
      #include <stdio.h>
      #include "libmdxmini/mdxmini.h"

      int main(int argc, char** argv)
      {
          t_mdxmini mdx;
          char title[100];
          mdx_open(&mdx, argv[1], argv[2]);
          mdx_get_title(&mdx, title);
          printf("%s\\n", title);
      }
    EOS
    system ENV.cc, "mdxtest.c", "-L#{lib}", "-L#{Formula["sdl2"].opt_lib}", "-lmdxmini", "-lSDL2", "-o", "mdxtest"

    result = shell_output("#{testpath}/mdxtest #{testpath}/pop-00.mdx #{testpath}").chomp
    result.force_encoding("ascii-8bit") if result.respond_to? :force_encoding

    # Song title is in Shift-JIS
    # Trailing whitespace is intentional & shouldn't be removed.
    l1 = "\x82\xDB\x82\xC1\x82\xD5\x82\xE9\x83\x81\x83C\x83\x8B         "
    l2 = "\x83o\x83b\x83N\x83A\x83b\x83v\x8D\xEC\x90\xAC          "
    expected = <<~EOS
      #{l1}
      #{l2}
      (C)Falcom 1992 cv.\x82o\x82h. ass.\x82s\x82`\x82o\x81{
    EOS
    expected.force_encoding("ascii-8bit") if result.respond_to? :force_encoding
    assert_equal expected.delete!("\n"), result
  end
end

__END__
diff --git a/Makefile b/Makefile
index 9b63041..ff725c3 100644
--- a/Makefile
+++ b/Makefile
@@ -43,6 +43,7 @@ FILES_ORG = COPYING AUTHORS
 LIB = $(OBJDIR)/lib$(TITLE).a

 LIBS += $(LIB)
+LIBS += -lm

 ZIPSRC = $(TITLE)`date +"%y%m%d"`.zip
 TOUCH = touch -t `date +"%m%d0000"`
diff --git a/mak/general.mak b/mak/general.mak
index 6f88e4c..c552eb3 100644
--- a/mak/general.mak
+++ b/mak/general.mak
@@ -17,10 +17,16 @@ CFLAGS = -g -O3
 OBJDIR = obj
 endif

-# iconv
+# iconv and -fPIC flags
 ifneq ($(OS),Windows_NT)
-CFLAGS += -DUSE_ICONV
-LIBS += -liconv
+  UNAME_S := $(shell uname -s)
+  ifeq ($(UNAME_S),Darwin)
+    CFLAGS += -DUSE_ICONV
+    LIBS += -liconv
+  endif
+  ifeq ($(UNAME_S),Linux)
+    CFLAGS += -fPIC
+  endif
 endif

 #
