class Omake < Formula
  desc "Build system designed for scalability, portability, and concision"
  homepage "http://projects.camlcity.org/projects/omake.html"
  url "https://github.com/ocaml-omake/omake/archive/refs/tags/omake-0.10.6.tar.gz"
  sha256 "f84f4cbb18a075782a7432bbf9abd5ef177eb0603fc1c69afffce8c2c25e30ee"
  license "GPL-2.0-only"
  head "https://github.com/ocaml-omake/omake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:omake[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "e6f7078311531e5160b87ecc20e5e8cff4bc6cca6aff53a802d94f361d7e4eb5"
    sha256 arm64_sonoma:   "f04d59c0ab2c129aff0e9bae5aa757a83e58f48dc10eea0ba7984e187bbd186b"
    sha256 arm64_ventura:  "94c636910242c5431bf03e0cd3d5c8f2972a48ad821ba36443ce603c44c84f70"
    sha256 arm64_monterey: "40ad54dcd5bef35cfb5ab3e7cb7b5f81e03c1b313b1f7c74e715b6ea6c6353f7"
    sha256 arm64_big_sur:  "a980b712dacb260d0ec4b2121545cdec4a1534ca95976e10b6edfb6eb2137569"
    sha256 sonoma:         "2e1d7068251a93c64a6331e5b6e891a208bee1cd93ef0dec6370d468cd80d793"
    sha256 ventura:        "3794f8d448da10ad33558e4a7390f8e657a4de09a84db6933387f1f59da0603c"
    sha256 monterey:       "f41e4e4311dd134634010373863ef6ab0830c0c4bbb210590c8e2975b10fe35d"
    sha256 big_sur:        "8dd4cb8d9e79996dc69c9205dfddba7e7e530971f197c2f40d306818afb6a97e"
    sha256 x86_64_linux:   "5d2038dba034f18eae8f32a98f526ef30b45ceae8ca6bd103b3e083267ab2695"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "ocaml-findlib" => :test

  conflicts_with "oil", because: "both install 'osh' binaries"
  conflicts_with "oils-for-unix", because: "both install 'osh' binaries"
  conflicts_with "etsh", because: "both install 'osh' binaries"

  def install
    system "./configure", "-prefix", prefix
    system "make"
    system "make", "install"

    share.install prefix/"man"
  end

  test do
    # example run adapted from the documentation's "quickstart guide"
    system bin/"omake", "--install"
    (testpath/"hello_code.c").write <<~EOF
      #include <stdio.h>

      int main(int argc, char **argv)
      {
          printf("Hello, world!\\n");
          return 0;
      }
    EOF
    rm testpath/"OMakefile"
    (testpath/"OMakefile").write <<~EOF
      CC = #{ENV.cc}
      CFLAGS += #{ENV.cflags}
      CProgram(hello, hello_code)
      .DEFAULT: hello$(EXE)
    EOF
    system bin/"omake", "hello"
    assert_equal shell_output(testpath/"hello"), "Hello, world!\n"
  end
end
