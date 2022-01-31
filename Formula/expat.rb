class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_3/expat-2.4.3.tar.xz"
  sha256 "b1f9f1b1a5ebb0acaa88c9ff79bfa4e145823b78aa5185e5c5d85f060824778a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "94238b974a7bff73e18efb14d41e67c3568a678a50f9932c05ec79cc3e205c77"
    sha256 cellar: :any,                 arm64_big_sur:  "674ecd0c906963d97b67f22f590c334256550a9328480e93d3d909300c6b5752"
    sha256 cellar: :any,                 monterey:       "2554f17ec818c20f3d01b584da88f735635128df229e513c09d732551bd3e4ce"
    sha256 cellar: :any,                 big_sur:        "4d636004a158c35f52dceb4dbb38182a67c9d17600f4aa61c114b5122154c665"
    sha256 cellar: :any,                 catalina:       "7abf3ea85305e079fd48ee551bce6be9126273b54b2a1b608ac5bd5eb26704cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b7b8a3fa2f3f4d172f73d034b28c93351de39154c8d85fc6a6a910d28650f3"
  end

  head do
    url "https://github.com/libexpat/libexpat.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    cd "expat" if build.head?
    system "autoreconf", "-fiv" if build.head?
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--with-docbook" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "expat.h"

      static void XMLCALL my_StartElementHandler(
        void *userdata,
        const XML_Char *name,
        const XML_Char **atts)
      {
        printf("tag:%s|", name);
      }

      static void XMLCALL my_CharacterDataHandler(
        void *userdata,
        const XML_Char *s,
        int len)
      {
        printf("data:%.*s|", len, s);
      }

      int main()
      {
        static const char str[] = "<str>Hello, world!</str>";
        int result;

        XML_Parser parser = XML_ParserCreate("utf-8");
        XML_SetElementHandler(parser, my_StartElementHandler, NULL);
        XML_SetCharacterDataHandler(parser, my_CharacterDataHandler);
        result = XML_Parse(parser, str, sizeof(str), 1);
        XML_ParserFree(parser);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end
