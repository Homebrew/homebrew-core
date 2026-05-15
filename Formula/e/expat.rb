class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_8_1/expat-2.8.1.tar.xz"
  sha256 "10b195ee78160a908388180a8fe3603d4e9a12f4755fbf5f3816b23a9d750da0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6c0b51cff718474971c0c8c3bf22777d39c561bbb20d6472b9c5af92a4a63339"
    sha256 cellar: :any,                 arm64_sequoia: "21857ba44f54e48a4048fda9a0f38e25d6abfdb94fe373d01c21bedfc72b6967"
    sha256 cellar: :any,                 arm64_sonoma:  "030fc6b70ba08652ce44d56dd5937c45fb973dc3a8afe70fb2ffd10eb7588adc"
    sha256 cellar: :any,                 sonoma:        "3d422a8ca495c64d5c58eebd814dd79a77f5c7fefbae66a1e224ef4b878d9d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744dc4e11f8d59a2b3e7c7235fa478ea95c8b2c0105b444ccc17a426c4821892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22baf729b24113da4db4c9736a595f1814bc33c305df78313d5229d78599659"
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
