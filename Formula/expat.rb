class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_2_6/expat-2.2.6.tar.bz2"
  sha256 "17b43c2716d521369f82fc2dc70f359860e90fa440bea65b3b85f0b246ea81f2"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    sha256 "b4ef17fd554af88d5f5a18ed01f5668d448d37f873ed62fb81b5b9d6610a5af1" => :mojave
    sha256 "f40e7de5136c5cebad824d0977040d6a12ce88d53131a37ade357b069759001b" => :high_sierra
    sha256 "42bbcc51ea53b2eccc49d10fcf8d7e90d3061fb7f1e35e6f58e8b8adf6fdceeb" => :sierra
    sha256 "ca9ef3c3c89d70794872e6b7dd2eed560008db47efa16c6c8fad3258940e3263" => :el_capitan
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
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
