class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_7_3/expat-2.7.3.tar.lz"
  sha256 "4cb8ec847a42d97fe4e9ee4fb516aca79cd41667e13a3982124e11c204bf2b9d"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a8a736373b1ff544a1928a441b8c7bff432eeef79150952a135d4338b80a948d"
    sha256 cellar: :any,                 arm64_sequoia: "cce13237e11552f73969092db97b88b014e1258299421b1c2e5e7ea876227553"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf2b3e08565d092b4a927a941055cd4177deea3efecd986ec4d350d6328e40a"
    sha256 cellar: :any,                 sonoma:        "4615123d8a742503006ca75fca2de8b383e33dd79df636291f1b5671daa4e1f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fdebb63fcb9996acf86ce21b91c17f9c37d547c48b86e65ea4607394dde6c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcaf94dc832299d32dc5dd5c33e6d6df43349b881e7ca798ffe7ca0e9e06e8b"
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
