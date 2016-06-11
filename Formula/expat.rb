class Expat < Formula
  desc "XML 1.0 parser"
  homepage "http://expat.sourceforge.net"
  url "https://downloads.sourceforge.net/project/expat/expat/2.1.1/expat-2.1.1.tar.bz2"
  mirror "https://fossies.org/linux/www/expat-2.1.1.tar.bz2"
  sha256 "aff584e5a2f759dcfc6d48671e9529f6afe1e30b0cd6a4cec200cbe3f793de67"
  revision 1

  head ":pserver:anonymous:@expat.cvs.sourceforge.net:/cvsroot/expat", :using => :cvs

  bottle do
    cellar :any
    sha256 "19c2504bb9cec6d2ef25bc8e2d9b1e682da3e7caf00a32cc367c11b94b8e7428" => :el_capitan
    sha256 "592e8edab162c718262f6dae55854ad34583cf0a58f9a7af762a83916d2986fc" => :yosemite
    sha256 "473d07e8ec8e2a17bec5bc3ed9b65e53508423f9e282f1fa56d90d81fe754bcd" => :mavericks
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  # http://seclists.org/oss-sec/2016/q2/360
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1c9ee45548b75/expat/CVE-2016-0718-v2-2-1.patch"
    sha256 "575f8d45835b917da833106ee4cb92efd98c5c1284f6f437aaf65bbc63edd767"
  end

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
