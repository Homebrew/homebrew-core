class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com/"
  url "https://gitlab.com/dps8m/dps8m/-/archive/R2.0/dps8m-R2.0.tar.gz"
  sha256 "bb0106d0419afd75bc615006bd9e3f1ff93e12649346feb19820b73c92d06f0d"
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c106049f35d645b200c12f0fc5285b7a6e4fc26074817f9fd96db7f437d777a6"
    sha256 cellar: :any,                 arm64_big_sur:  "7b6df2db14bb9e099eb1b2003c0ba410e62d4bd81046e425f6db437894938e0c"
    sha256 cellar: :any,                 monterey:       "96edf4edaa1bce0e86156ded85877536cb36d889f555011709f516f8bcd2eacd"
    sha256 cellar: :any,                 big_sur:        "a8f615026cb8660c2d7684387b17d1f39e9b93c547a18adf125a88610d5466d8"
    sha256 cellar: :any,                 catalina:       "d9d967a0c7dad0b63ea6327102cb5d83345ff6b0bcdbf754398c1a5cdb0b0916"
    sha256 cellar: :any,                 mojave:         "2c148e6bcd3a83e91b6b327d285bcfbb6490a3f7d8f08c4d904a6b907fbe61cf"
    sha256 cellar: :any,                 high_sierra:    "600be3242396b61b2e807ed850cd65fc30a4676993c44c5171488954be496ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68382b2ed447d527096d1d3e796233859940e423b3d6263821f6454dee91c52c"
  end

  depends_on "libuv"

  uses_from_macos "expect" => :test

  def install
    # Reported 23 Jul 2017 "make doesn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8
      set timeout 30
      expect {
        timeout { exit 1 }
        "sim>"
      }
      set timeout 10
      send "help\r"
      expect {
        timeout { exit 2 }
        "SKIPBOOT"
      }
      send "q\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_equal "Goodbye", shell_output("expect -f test.exp").lines.last.chomp
  end
end
