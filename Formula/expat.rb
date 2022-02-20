class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_5/expat-2.4.5.tar.xz"
  sha256 "f2af8fc7cdc63a87920da38cd6d12cb113c3c3a3f437495b1b6541e0cff32579"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9d680e74b015db0e06de36b9d7b7cdc864e98d725fc305c779182a2a2af5331"
    sha256 cellar: :any,                 arm64_big_sur:  "7ccfae4a252c0ef1fd9d624eea27d495612fcfd80dc0542c7f6dd3332b83697e"
    sha256 cellar: :any,                 monterey:       "726a2dc83f94626aa93df7c9af7fef20b1c91cf3a30f1b95d43661d8be08d78f"
    sha256 cellar: :any,                 big_sur:        "f0c61ce1fdd13b10c8559c6b653000b153780a369b72ccb363ba8fb7c0b2040b"
    sha256 cellar: :any,                 catalina:       "6da866d36166e01bc7f88e23da29f2062099e2e31ebec88aa3d61e864a722594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c38f4719e6c68e5a060034ebb4409c7a1e947785022df073f5dae5dccbe155"
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
