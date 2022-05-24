class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.xz"
  sha256 "f79b8f904b749e3e0d20afeadecf8249c55b2e32d4ebb089ae378df479dcaf25"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c87cbc27a23da1b9c22382d830a3553309bb1475201a375af648941330af9f4"
    sha256 cellar: :any,                 arm64_big_sur:  "9eff463ed55b86e151c5490d671933ebaefeefa0c6fb5233a74ac204b79185a2"
    sha256 cellar: :any,                 monterey:       "4a4f446d62d57087d1220c8bc145c0025b50086b94a9edaa2776d7246c5a0e6f"
    sha256 cellar: :any,                 big_sur:        "8148cbc1408b80b38c3811da65daea299a39858ff673cb355f3ac3b85bb93e66"
    sha256 cellar: :any,                 catalina:       "68dcfe4b36668a6dc84296c50a3f3ac6ec8cada56de37bfe233fd4fb7c500c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db13166d6a5bd0e19f82e9cd19f4a951ffff40cdfc29197e8143780444d0c204"
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
