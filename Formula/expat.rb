class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.xz"
  sha256 "1ea6965b15c2106b6bbe883397271c80dfa0331cdf821b2c319591b55eadc0a4"

  bottle do
    cellar :any
    sha256 "0b73f9ee4ce72d62afed2dd7301a343b6676bd348417b2ba190b5d05b8fddd1f" => :catalina
    sha256 "edb2f47c41a8bc3d4ad5a8c8333bef3a1d836632c1e780a9be4c41631d812857" => :mojave
    sha256 "64598b71bfd545da52504f0b48ef2f6c6adf5af43d5680ed34f9c48f59cc9020" => :high_sierra
    sha256 "5c44be4c6025bf688bb6c8d5de0402ed223da6360998678be20483bc9034ce3e" => :sierra
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
