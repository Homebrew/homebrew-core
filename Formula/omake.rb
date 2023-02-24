class Omake < Formula
  desc "Build system designed for scalability, portability, and concision"
  homepage "http://projects.camlcity.org/projects/omake.html"
  url "https://github.com/ocaml-omake/omake/archive/omake-0.10.6.tar.gz"
  sha256 "f84f4cbb18a075782a7432bbf9abd5ef177eb0603fc1c69afffce8c2c25e30ee"
  license "GPL-2.0-only"
  head "https://github.com/ocaml-omake/omake.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:omake[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ccb4ab08ba88836f3179967c0c118e1681adf9a408812c40f38e244ce6f4f0f5"
    sha256 arm64_monterey: "468982988c821b3a65bc02a244398c2e1a6c4a2bcdd5115af05a98e4da52e804"
    sha256 arm64_big_sur:  "544ac68e5eea28f84324223b827050c5fb96e5e9bb86e0ec15d25ca6e9e8af4c"
    sha256 ventura:        "8e84c6f018f584e61b83b0a503b4205ae84c407bec34cdca890d469a030e5839"
    sha256 monterey:       "cc8b8e8275e34b5f718ab0bd17a14da3064da00c467abe27c3718a8ed8abbebc"
    sha256 big_sur:        "9d7cd18e5d23347cd547221021d2f613e001dc7ecd27d8cfce3714c5b77526b6"
    sha256 catalina:       "a3420c41c140cdbf160ae44233dec2edf971f8b0177ff2f4d03a2e58f22cc0fe"
    sha256 x86_64_linux:   "4fb8e22103867842e42543bfee9ee440a1589b3b56b5d00bcf25e125956d251c"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "ocaml-findlib" => :test

  conflicts_with "oil", because: "both install 'osh' binaries"
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
