class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_6_4/expat-2.6.4.tar.lz"
  sha256 "80a5bec283c7cababb3c6ec145feb4f34a7741eae69f9e6654cc82f5890f05e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f47cdcb2b385e14a695b7cf0c11ad2810c7d80860730180b70c315ed4f1aefb"
    sha256 cellar: :any,                 arm64_sonoma:  "60a7805061d5eb779c8798b8fc3fa0c1cb3063e6786471d329687de38cfde52f"
    sha256 cellar: :any,                 arm64_ventura: "69954446c870bfbea2df1e26784ac789456d654754f75bd94297bf89bcea66ad"
    sha256 cellar: :any,                 sonoma:        "e98fa8b9fe6d09089fbf75356463f1a4aefd1efb8069436fab2266a8efc2e855"
    sha256 cellar: :any,                 ventura:       "e9563e83b969283e97681f9358a333727b9a0f8145c01fa942a8045adbfbb48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d426857dc98acacb3a4c3bb6d7646dadf65bb4c154a4c6681103de42fa2f981e"
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
