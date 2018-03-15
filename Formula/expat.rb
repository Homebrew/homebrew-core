class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2"
  sha256 "d9dc32efba7e74f788fcc4f212a43216fc37cf5f23f4c2339664d473353aedf6"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    sha256 "0ef65624ae99120f21c4ef319a8a056697db296efd9bbd662529334711c7bc15" => :high_sierra
    sha256 "653edd989854be055f50853486a4945d68e49cc8f6e944776bf2be67b51ac304" => :sierra
    sha256 "618683020e64ef1ca99d0c2f388262cf32117d93d7f047bf8251461d8af3f04e" => :el_capitan
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
