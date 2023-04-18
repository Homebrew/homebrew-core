class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-2.5.0.tar.xz"
  sha256 "ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:[._]\d+)*)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c7cd6f81b3171b8858df622e03582d983053c9fab61c6786690dc21915b37bc"
    sha256 cellar: :any,                 arm64_monterey: "b2da23ec6cc32aa2cfabf746594e905cddb76b8351b40d317b9d4231cb782f13"
    sha256 cellar: :any,                 arm64_big_sur:  "be121e65ca172e88af2d28b7e8a13fab9794ce1df74c597d34011c3dd7cc9a72"
    sha256 cellar: :any,                 ventura:        "1c45270bdb0c45c810cd90457cca0aa2e48e25762624443b59d3f0c1ed9f9ebf"
    sha256 cellar: :any,                 monterey:       "ece2dd08612bb84c394074eea1ee11249678b716d35ae8a29a3369f54a10e9b8"
    sha256 cellar: :any,                 big_sur:        "fbad8bd585ca3b1fe7a9f65ca014893ae06d65727c7edf29e9c16ddd06b49242"
    sha256 cellar: :any,                 catalina:       "0cb52adc9b8b11faedd3e6a4bc579d3aa4c90ee451282130fc885afb884c1d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2b581249b57581db4178a3f219f94f75d8b540867cc27fe1b809b3d32f1772"
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
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--with-docbook" if build.head?
    system "./configure", *args
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
