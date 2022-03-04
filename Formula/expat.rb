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
    sha256 cellar: :any,                 arm64_monterey: "c9e0056f56848ed26592e446033e248a14fb46a4ed91c9be0e9718ca1e8a12ba"
    sha256 cellar: :any,                 arm64_big_sur:  "838d23f34727620bb6faed52d4d326cad2cdc4aa6374ae27666149e0b0349eca"
    sha256 cellar: :any,                 monterey:       "dfb3579a24fc98c3b588a282536dbe42bc2a9bb2f53fb647c530761a4facb89c"
    sha256 cellar: :any,                 big_sur:        "f8d374de7fe0d6637067e11aeb5303cd4d34ab831a9f28499ba141e235a504d2"
    sha256 cellar: :any,                 catalina:       "8bb5c75d744c7e9e1725e3afb4256cf5c54d41f82bdce592b7fba66d809d59ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e27bc5f5b3dc77797fe5a1efd8bc0c370a0ecb3b8136b7c3fdc63c43522170"
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
