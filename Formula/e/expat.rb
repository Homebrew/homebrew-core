class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.lz"
  sha256 "b8713f2d3cb3a3eee9ab763f66aa68f93cf6820bccf1272a682cf79b99ae6fbc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d9cb8096d735b92ac15824e9d81626c51dbf93408367bd0d3024a2110f4fc382"
    sha256 cellar: :any,                 arm64_sonoma:   "1c7329cb4ca4f452ffd67a6f34e4527285470d889e4d4102c1f7c6388f15dd31"
    sha256 cellar: :any,                 arm64_ventura:  "3246047b6928bea9723f58599202fe1293ba1c54e9bbc5510b9fc3578fedd7dd"
    sha256 cellar: :any,                 arm64_monterey: "ec01bea86d59d1dcecad66e21cb3ac1534ef46371a97ebf33de26b4da1a618eb"
    sha256 cellar: :any,                 sonoma:         "7b53ec1a15c1ae7b117329e6e30554239c411609181d4f31583145f2d9b15a3b"
    sha256 cellar: :any,                 ventura:        "ad4ce3976e2a11dda91210ae4e451dd0363a3bbe339113728685f2795b56386b"
    sha256 cellar: :any,                 monterey:       "cbc2eda6e09156b4d70cec60890c9a06528d56564abfa027d2b6c5d1b2e5767e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2977263cdc1c6c153a5459eaee29016739f9cb727c243e55d48a4fe7e01a8d3"
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
