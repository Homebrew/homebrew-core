class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_8_3/expat-2.8.3.tar.xz"
  sha256 "f6256df90c906773d344da084402b7d3e4f22ed41b1a59c989098a83d3ea0c85"
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
    sha256 cellar: :any, arm64_tahoe:   "2f1a40261e1149a65dde4918aa586f4df3a4315a0fdc05929990841ec77a927f"
    sha256 cellar: :any, arm64_sequoia: "ddeabd217a8727921f6cfb4372b903c38b5002a2e96340e566c06f368db3533c"
    sha256 cellar: :any, arm64_sonoma:  "969b76dd1d05766c8a08e82bd0b8b89e26845e51d296b62f535a7f9f79296c6a"
    sha256 cellar: :any, sonoma:        "f3d074919307bdc8b8dd6b140a1cf90479256055b0beccfe4518cf18ae2c1031"
    sha256 cellar: :any, arm64_linux:   "95a9ea74ea19a28f1dfe4bdb8dfd8aaffcf0b2db5e606a7ddef20b760e05c3b4"
    sha256 cellar: :any, x86_64_linux:  "004e4183005330ce9ae561d556019bfd0a39a3b273cc591c46cbd52f694df400"
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
