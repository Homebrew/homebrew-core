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
    sha256 cellar: :any,                 arm64_sonoma:   "cfcec3a57f17f190581a1f3dc959de165152bd2d8b83db6c176f00e4dd65eb9f"
    sha256 cellar: :any,                 arm64_ventura:  "9a675f266716d80014a378ea62c50cdf06c6cdfd19e1d1f40a04a39a22a06472"
    sha256 cellar: :any,                 arm64_monterey: "71dc09c80c310ba0c4a99519010dfe67ca5a45972e12f80ed82feb435b87d640"
    sha256 cellar: :any,                 sonoma:         "e26a9152e3517191d95ecdbe59365a336c4189750493f6f2f293a3c68c7d155f"
    sha256 cellar: :any,                 ventura:        "7efe128f6496ec8daacd44b992449112427a6b5db3a5d4d70cfd0b7ed9e57af7"
    sha256 cellar: :any,                 monterey:       "7a943ce114b36d8581a7bea80b7d56b33aa9b9a33a8ed8400b600ac34d7043a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d8e476d4e3ec9c02be088eb7c9d5cee7376c2206f00a90229f279674ebe0de"
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
