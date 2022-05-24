class Omake < Formula
  desc "Build system designed for scalability, portability, and concision"
  homepage "http://projects.camlcity.org/projects/omake.html"
  url "https://github.com/ocaml-omake/omake/archive/omake-0.10.3.tar.gz"
  sha256 "5f42aabdb4088b5c4e86c7a08e235dc7d537fd6b3064852154303bb92f5df70e"
  license "GPL-2.0-only"
  head "https://github.com/ocaml-omake/omake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:omake[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "725e9f575aa66632678bf58a4a358d1b7bd30a2cb2024be2f37a49cfed2a0adb"
    sha256 arm64_big_sur:  "3083df4b79088af402da7dbc31f1ff7368c656029bc328bb984a0ad3e86d317b"
    sha256 monterey:       "33fc23f440db2f5f7950bb818aff16d46dbe46993faded5130c8e411b6e79c6f"
    sha256 big_sur:        "983b6e4988b2bb1c5200e413c7a6152b196df9610c41c4768addca6a0355e1f5"
    sha256 catalina:       "21933568db9ed765a0bf8c1f04b9f38e5923b6a320372a570499b221fb2afe6d"
    sha256 mojave:         "f54a0498316969552424a646ef36b15c567162e689e04203c95a5f8a4536c589"
    sha256 high_sierra:    "587b563698dc29ea2c662ffa58458f45e212f131e3687a37d26d8f379f089588"
    sha256 x86_64_linux:   "8fe2949b2aa964a4310791453c27f1d05f8f693750ba0c9b8fad4b0d79580182"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "ocaml-findlib" => :test

  conflicts_with "oil", because: "both install 'osh' binaries"
  conflicts_with "etsh", because: "both install 'osh' binaries"

  def install
    system "./configure", "-prefix", prefix
    system "make", "install"
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
