class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.4/expat-2.2.4.tar.bz2"
  sha256 "03ad85db965f8ab2d27328abcf0bc5571af6ec0a414874b2066ee3fdd372019e"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    sha256 "e7691f8d7ff015e0d17c2e2fd56967ff6bcea49dd60becfd3eb8e03793588262" => :high_sierra
    sha256 "cf560bf57e8ba9ee38b9e114b1a3edbbad2ddec86c07b8641073ce93094f2080" => :sierra
    sha256 "c7f3b94d633261b1c653b78ab661815a8bf8391a8680d6d0f483f44ba4c22086" => :el_capitan
    sha256 "7ca48b81e9a6a8717647ea2a30042e046260a514bccc80d8918908c2dd32c576" => :yosemite
  end

  keg_only :provided_by_osx, "macOS includes Expat 1.5"

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
