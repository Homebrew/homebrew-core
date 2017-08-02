class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.3/expat-2.2.3.tar.bz2"
  sha256 "b31890fb02f85c002a67491923f89bda5028a880fd6c374f707193ad81aace5f"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    sha256 "695b20a2db6da52fa0dd6a8a27b625ebbbbde60501d467bfdb2c35c014560f95" => :sierra
    sha256 "fc2aeee22d324256fd60e57207a6b25ae73321007ad937b0c4d079c4525872d8" => :el_capitan
    sha256 "cdf5f497c262b7ea270e38618ff4c54d7f6da22dc3c97355e977dfcb45223b08" => :yosemite
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
