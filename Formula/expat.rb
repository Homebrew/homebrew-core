class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_9/expat-2.4.9.tar.xz"
  sha256 "6e8c0728fe5c7cd3f93a6acce43046c5e4736c7b4b68e032e9350daa0efc0354"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:[._]\d+)*)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2aecb76db9667c371242d0d6f610249e15ee78e792cd0c53d3fb0e00ba7f3ac"
    sha256 cellar: :any,                 arm64_big_sur:  "c7010f5ae496405695a9c14e00def88cdc3d983029bc3943c85bf266c6b16082"
    sha256 cellar: :any,                 monterey:       "33de0fb29eaca0a761486736ba635361fc9d9ed6f2dbd512db3604a68079eba4"
    sha256 cellar: :any,                 big_sur:        "132a9beedd4682a30a58409f7f4ef0c77fbd4e60cb436d008b0632ad47062fea"
    sha256 cellar: :any,                 catalina:       "7ba700e0cc0e1e5684fdf01392bf8be36178f4201b6dc6dda12d78c51c45cfba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f4d2e3ae86f20f3252d050485b36e7fab8851355cde4e90f260768e254c371"
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
