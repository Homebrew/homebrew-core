class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_8_4/expat-2.8.4.tar.xz"
  sha256 "656ae1cc8da3b4ea513bb4e254f33e6243938084c0ec6239da873376b09985a7"
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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "427ed7e45ea4c3cb1bad9599b10a771bbe27f38e877cce8088283be861e01c2c"
    sha256 cellar: :any, arm64_sequoia: "28c818bc057acef8f15389fd89a34cb8789be568a3c505e85b2fb07c206df3c4"
    sha256 cellar: :any, arm64_sonoma:  "fff75895441597ef6fe383c581ef3cde3150646e4351a3d4e19b255f20532d37"
    sha256 cellar: :any, arm64_linux:   "d48ea879a36ca8f7a26c0004e4d2ea1309483b206aebeb0fd606fd80fc8e046a"
    sha256 cellar: :any, x86_64_linux:  "9874d65597cbca2af8c9ddbf3e9a3c2577ee20ad447d6b67ff2cdf05f855b58e"
  end

  head do
    url "https://github.com/libexpat/libexpat.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  deny_network_access!

  def install
    if build.head?
      cd "expat"
      system "./buildconf.sh"
      args = ["--with-docbook"]
    end
    system "./configure", *args, *std_configure_args
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
