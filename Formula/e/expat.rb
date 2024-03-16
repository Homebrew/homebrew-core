class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_6_2/expat-2.6.2.tar.lz"
  sha256 "d276ffa9602e0c5f289f33fab7b3a9c86da446092642a09cd3c0c8e51f50d862"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b8420489dcc4ab81dffe9cc85c68bd972091a15c337c6e4eef497207466dca2a"
    sha256 cellar: :any,                 arm64_ventura:  "c2ec439414e151b4f2dbf803148c445e27877fea10596af7cdc4e3ef92e82115"
    sha256 cellar: :any,                 arm64_monterey: "6800ac7e9889cbaa8f6f889eb6707fd19ec9b13f9c7bb0dfad6081d68c0a28af"
    sha256 cellar: :any,                 sonoma:         "65d7e44090e2f5e45b707de7fd9092ae21edd48d32f3ce5dcc25d869cb18acd9"
    sha256 cellar: :any,                 ventura:        "87422561e9e7e4ef75a63c680388be83b5529403451013f1c1281caf7b3edaa5"
    sha256 cellar: :any,                 monterey:       "b40b8c732f54fc057da3528b33df3245f1dc9ccfb3f2deb6b0380abc3d8c8a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423613f5bd79c5ca785813dde2b8c031610d20ea3c9b730dc86b67597f946105"
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
