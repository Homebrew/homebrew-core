class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.xz"
  sha256 "cf032d0dba9b928636548e32b327a2d66b1aab63c4f4a13dd132c2d1d2f2fb6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5707bf186fa91f8196316967ad00e629e33b4cb98c0ae27503a57caa3dbc6216"
    sha256 cellar: :any,                 arm64_big_sur:  "fac282dc87d050030a34ad8b6fdae89dd5ecc1c08d03f0d9efc49c9396daaed8"
    sha256 cellar: :any,                 monterey:       "3a0842f8aaf57a65a2e9a8d214f984f578d582b2e194982d3064e892bd985141"
    sha256 cellar: :any,                 big_sur:        "18ebdde1356dd48de8c575eb2479dbb6556f7bef7a2b48a64c0f018dd79af1dc"
    sha256 cellar: :any,                 catalina:       "b679f0f8807216636b660b01b3b8f5506e245e4f6160450f408f6446d3017e48"
    sha256 cellar: :any,                 mojave:         "45004cc0adb2a75d9d0f965a0fc3f087059907aeed9c5f8b36bbb3babce4a6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb9d218fe6fbfb86d5aa69f6ac7087b6a082e9b6739a51a701c1a7f3d7d3642"
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
