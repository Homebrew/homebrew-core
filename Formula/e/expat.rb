class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_7_4/expat-2.7.4.tar.lz"
  sha256 "882bb3c124cdfd6d594818276f3ea851b780473a722385150a5793277635fcae"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3fbc5fb0909f92b7ea4dfaf1bbf539bab9601c5ece083706b63717835809a4b"
    sha256 cellar: :any,                 arm64_sequoia: "4ae3b12a096133bbe5b0335ce1ba9e540a2e3f7258d3564d3acd30a496c859b9"
    sha256 cellar: :any,                 arm64_sonoma:  "4a0a6cfb3d203a3a9f48eae5e9630060edaea0a0d88c96b637e10a3cbd07f2e9"
    sha256 cellar: :any,                 sonoma:        "57abe74689ba80399ff73e144d5798b8aee8f17e4a8f9bec90fbfeb4dec6c66e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77a85b00651abbacd0c092a4b5a103524f2fc7b9527423b3d623c603565910e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64be96154732d144366f78afde810acc3c4d19ee550c972b5c98a3b6921f8cf9"
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
