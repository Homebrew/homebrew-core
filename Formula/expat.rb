class Expat < Formula
  desc "XML 1.0 parser"
  homepage "http://expat.sourceforge.net"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2"
  mirror "https://fossies.org/linux/www/expat-2.2.0.tar.bz2"
  sha256 "d9e50ff2d19b3538bd2127902a89987474e1a4db8e43a66a4d1a712ab9a504ff"
  head ":pserver:anonymous:@expat.cvs.sourceforge.net:/cvsroot/expat", :using => :cvs

  bottle do
    cellar :any
    sha256 "5e88f87911f6bc4da80d7c184bdda34e6c8de41740f6536602517a933e9ea9bb" => :sierra
    sha256 "b12ee86df3f1faa5eb07e2624ab464428d9b96fb09cadc25a20fe7a065459f54" => :el_capitan
    sha256 "228e8d539fc0447150a0f1508cad4ab33347e45178964966df0802389b0c5a3d" => :yosemite
    sha256 "48dcc5c1d0dedd3ebac9e238ff5e5cf1d725577062f5902cb58cfcb9f105d5f2" => :mavericks
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
