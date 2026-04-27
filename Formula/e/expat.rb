class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_8_0/expat-2.8.0.tar.lz"
  sha256 "35b02d84d809117506064bb388b3bbc7f421d629d2ba565f6d1f1c369b85fcd2"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a480f2ed56d18b115f55845c2fe5db91422af82a8488b8126488279e0b9f4570"
    sha256 cellar: :any,                 arm64_sequoia: "c2afce67b202ee45a1f2926c37d3709e14e8d0bc30f4434c6190f01e1833cf8f"
    sha256 cellar: :any,                 arm64_sonoma:  "5acc0e33d58ccba66f88e517cd5a288e27bbf613f8ed332bc27e17f07294ec18"
    sha256 cellar: :any,                 sonoma:        "6cc25fd379a99809bacbc2c557804b46f3690ab5962fadcd78a528f0ff805796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b1a2ac26414b3f7ca04fba288d68f8c4100131a1a6114586744832824e51ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf220faaac73feac0ce7a0c28a0e4ec21fb9cd885ea81ac9b04df7e2ba4a84bb"
  end

  head do
    url "https://github.com/libexpat/libexpat.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    cd "expat" if build.head?
    system "autoreconf", "-fiv" if build.head?
    args = ["--mandir=#{man}"]
    args << "--with-docbook" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end
