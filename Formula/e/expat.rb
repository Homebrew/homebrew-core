class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_11_0/expat-2.11.0.tar.xz"
  sha256 "61e7614b602201c28a189dafee78f5bceaee192bbde46a930752ff09cf5542fa"
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
    manifest_sha256 "ca6a50360c0b3154394bce7022c0ba3addb383a8b3629d61ab9f348ef820b3e8"
    sha256 cellar: :any, arm64_golden_gate: "0e8be62afddc9e967408bccb554fedb2388dd984b01c0ad66d17add2cbb126b1"
    sha256 cellar: :any, arm64_tahoe:       "60236e1bc7a8526ad2bbc8e80ea919e60521ced50d7fbae8e3505fb2574a3eb8"
    sha256 cellar: :any, arm64_sequoia:     "543b98eddd6d8067bd2188008c5344f611a346eb85bb7ba19318a04673a87184"
    sha256 cellar: :any, arm64_linux:       "4f08d765239bf8688edeb9a2ebcc0b028f3273f8515017ea02c645882df56cb1"
    sha256 cellar: :any, x86_64_linux:      "3eb5a1ea53d34e6e3a631096c5552665ca4f826dcaf04bb55d4126cd742df009"
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
