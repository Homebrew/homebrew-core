class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_4/expat-2.4.4.tar.xz"
  sha256 "b5d25d6e373351c2ed19b562b4732d01d2589ac8c8e9e7962d8df1207cc311b8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b06264f72ef3ae93b728d34bed0b0f76269189175436d1db4ad7932f4d0beb42"
    sha256 cellar: :any,                 arm64_big_sur:  "be935657a1afb856dff1d62ccef05c23a75457286d59dafd6e7467a6311f0b8d"
    sha256 cellar: :any,                 monterey:       "855f6ebb10eb903243199614bf884f6f36131fcd9df8c7fddf72d7fdd7e1a701"
    sha256 cellar: :any,                 big_sur:        "4d8e172f524ece9c4ad134fa24fe5d8c2bf26374384df011ffaf4fbaf52c780a"
    sha256 cellar: :any,                 catalina:       "dd9b2732bb6f33329abc1d4686bdcacca3fd8b3d8a8e93242df8c838809e6e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8901df5a5f24f348299b1c650d909bc955df828ea838ba4da524ff67bd453c5"
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
