class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_6_0/expat-2.6.0.tar.lz"
  sha256 "138438bab8658b049e6eba74aac11dd71c7bdd6bb80b3bc4c18bfa5a65f08249"
  license "MIT"

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)*)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06d6553da209b37643ade607a230e958fa1262ff46ead6a109843c0abecc5232"
    sha256 cellar: :any,                 arm64_ventura:  "610f48ccf2bc3f2fb5329e94c5ade89ed26f2ba106a025b83abeb2ac486b45ee"
    sha256 cellar: :any,                 arm64_monterey: "a8e07b13f145c4d1e06f998cbad90bb10072c9c636da6e03aece544ccb9783e9"
    sha256 cellar: :any,                 sonoma:         "62d8e5a77dc470b21ca267a7a8b5155caf9f3d21febfdec1869b3142c06edc22"
    sha256 cellar: :any,                 ventura:        "7c39b78a1376ce30df5465260a5e8771e324c46528416a8f28c9c23febbb2651"
    sha256 cellar: :any,                 monterey:       "909fce95b9e019e68d8af1a35c06645e3f15b28909160a2979dcf822eac12ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6f1e5edc36af9ece97877b7f8174d2df69ea2619c047d64e6fdf2458926ba25"
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
