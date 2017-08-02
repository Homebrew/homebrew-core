class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.3/expat-2.2.3.tar.bz2"
  sha256 "b31890fb02f85c002a67491923f89bda5028a880fd6c374f707193ad81aace5f"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    sha256 "2a1d8fe1378599a7ac58b62c0c4136bfd86936d323062ccfc88b53732e1d7f59" => :sierra
    sha256 "17166d4ca1a534b62c8482f00ffd239906d8393d6b8e8b6280997802e72cc080" => :el_capitan
    sha256 "f84abb141d73044a91070096d9a3a233c1a2d0af5f62a6a9d7ca0a02d845c6ee" => :yosemite
  end

  keg_only :provided_by_osx, "macOS includes Expat 1.5"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
