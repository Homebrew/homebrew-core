class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_7_1/expat-2.7.1.tar.lz"
  sha256 "baacdd8d98d5d3b753f2a2780d84b0bc7731be11cacdc1b98cb8ad73f0504e68"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e5392724170f8a1314c0db2077a1f30277e4941d1825554f1230092a483ef7c"
    sha256 cellar: :any,                 arm64_sonoma:  "4e9eb804bd04ea10e82d38e1080670b61f067d79e36c6f854f77a8773bb8c41c"
    sha256 cellar: :any,                 arm64_ventura: "55d44623dacceded1a48dd16b9107cab1a13036a7b251365fcf10a48f990d2d2"
    sha256 cellar: :any,                 sonoma:        "ef5fdbf19ba77546257b3222d96c50fb12b560ef55278310f2924ccc783a384b"
    sha256 cellar: :any,                 ventura:       "e6630e308b908b0cf9591223d03fd407356ea650ef4a68cb64c454a46397ebd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5d72c420ea82f5915e2ccf0f1ff569bb4501faca4ebe44901926cc78420fad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ff2ade2b1d0b3de72558f92507b8bfc9bdcdc2fce5c5e33e080dfffff9b83c"
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
