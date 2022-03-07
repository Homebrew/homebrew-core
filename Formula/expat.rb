class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_7/expat-2.4.7.tar.xz"
  sha256 "9875621085300591f1e64c18fd3da3a0eeca4a74f884b9abac2758ad1bd07a7d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "408bf452fc05b19374181724c6274e5f9b29d518feb42127c1ffeb286bf43c83"
    sha256 cellar: :any,                 arm64_big_sur:  "d3789c8ce49e9d03851aa8068a2529177f98dd1f876272df3c56c1116d4b33ce"
    sha256 cellar: :any,                 monterey:       "4d777539c7563e07f75bf99856aec1e582754ae9203cecf455ed63287d50e750"
    sha256 cellar: :any,                 big_sur:        "55928feabdedea649a97baaccae65b41315b46f0bf0c708d10ba0b61a76bfaa5"
    sha256 cellar: :any,                 catalina:       "a9c372ecafa68e41d9b676fbfd608f5d1f985fc94efd12bf4d7904e318aaeb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d90f22095cca714b764af2e2aca33b4e96d06fbf237775d64aa50b81525a1c8"
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
