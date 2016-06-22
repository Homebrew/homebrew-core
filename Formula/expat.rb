class Expat < Formula
  desc "XML 1.0 parser"
  homepage "http://expat.sourceforge.net"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2"
  mirror "https://fossies.org/linux/www/expat-2.2.0.tar.bz2"
  sha256 "d9e50ff2d19b3538bd2127902a89987474e1a4db8e43a66a4d1a712ab9a504ff"
  head ":pserver:anonymous:@expat.cvs.sourceforge.net:/cvsroot/expat", :using => :cvs

  bottle do
    cellar :any
    sha256 "19c2504bb9cec6d2ef25bc8e2d9b1e682da3e7caf00a32cc367c11b94b8e7428" => :el_capitan
    sha256 "592e8edab162c718262f6dae55854ad34583cf0a58f9a7af762a83916d2986fc" => :yosemite
    sha256 "473d07e8ec8e2a17bec5bc3ed9b65e53508423f9e282f1fa56d90d81fe754bcd" => :mavericks
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  def install
    ENV.universal_binary if build.universal?
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
