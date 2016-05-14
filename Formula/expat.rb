class Expat < Formula
  desc "XML 1.0 parser"
  homepage "http://expat.sourceforge.net"
  url "https://downloads.sourceforge.net/project/expat/expat/2.1.1/expat-2.1.1.tar.bz2"
  mirror "https://fossies.org/linux/www/expat-2.1.1.tar.bz2"
  sha256 "aff584e5a2f759dcfc6d48671e9529f6afe1e30b0cd6a4cec200cbe3f793de67"

  head ":pserver:anonymous:@expat.cvs.sourceforge.net:/cvsroot/expat", :using => :cvs

  bottle do
    cellar :any
    sha256 "27de8d30eb5d716008c5483b97ec4c67d976169da1301c25a1895f2ac6d09c67" => :el_capitan
    sha256 "e4b7cccc0fe310ec87828cb96e88ffb4ae7ef3e00dd4417d423dd59b51282924" => :yosemite
    sha256 "0fafd06b26fcdc5f5c1c634ce8527151f615e74f8c06a42891cdefce19a9405f" => :mavericks
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
    system ENV.cc, "test.c", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end
