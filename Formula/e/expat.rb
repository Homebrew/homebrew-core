class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_7_5/expat-2.7.5.tar.lz"
  sha256 "975e76ab8a5625190bd04a577fa9efc246798c25b8ec665acb6f7951be8b0646"
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
    sha256 cellar: :any,                 arm64_tahoe:   "04fed88fc5ea63211829695ae832be622bba9b224f8c84f4882a6776b3f5cca7"
    sha256 cellar: :any,                 arm64_sequoia: "266fc399a590e756abd38ce5b2923c397876253704dd4c3fde01816dffb7843e"
    sha256 cellar: :any,                 arm64_sonoma:  "8b5d48b744487494f5649db6f7a971bff4e48aac5fc48b16c19d6622787b04d1"
    sha256 cellar: :any,                 sonoma:        "68d8779156448d1396abf021453156bede9a0c119e35b46f64cb901fe7dc5f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a79da446d9ca71589c8951de336f0b4851828007ee9ee03f3272b4ccc288e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b6001a08f1a82a9bd2e23d0048f6d7fd812d14f5526f482ccff75b674dcc39"
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
