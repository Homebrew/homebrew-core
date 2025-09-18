class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_7_2/expat-2.7.2.tar.lz"
  sha256 "23aaa1c5c56dc10178630331f9adbb465e8c066b105c233f4198359e3ba30716"
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
    sha256 cellar: :any,                 arm64_tahoe:   "246ba8ebbde84f2237d896dfad42de050493ff1edaa5b8ee396f8e116cf14822"
    sha256 cellar: :any,                 arm64_sequoia: "00dfcaa00a49ac59fde827e032d433efa3fcbf6354a39f97d5889d4d4c5ab8fd"
    sha256 cellar: :any,                 arm64_sonoma:  "6ecdcd77ae12e1130eaf7a909b460d2b6520a6558ca1bba7f5f24a3ab4248542"
    sha256 cellar: :any,                 sonoma:        "0f418b3c5e535f59f0400072ab487c49ce3f96ba871d26602de2f88dab984125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6590309f12ade899fd5d89f3457facd8e4c8909b85ffc9d3d9f491cdb0d085b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37454cb0d7ed9011d2f8a314dd37af3e00ef0d24fc460fb64e1d38a2c7744c8e"
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
