class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com"
  url "https://gitlab.com/dps8m/dps8m/-/archive/R2.0/dps8m-R2.0.tar.gz"
  sha256 "bb0106d0419afd75bc615006bd9e3f1ff93e12649346feb19820b73c92d06f0d"
  head "https://gitlab.com/dps8m/dps8m.git"

  bottle do
    cellar :any
    sha256 "d9d967a0c7dad0b63ea6327102cb5d83345ff6b0bcdbf754398c1a5cdb0b0916" => :catalina
    sha256 "2c148e6bcd3a83e91b6b327d285bcfbb6490a3f7d8f08c4d904a6b907fbe61cf" => :mojave
    sha256 "600be3242396b61b2e807ed850cd65fc30a4676993c44c5171488954be496ce4" => :high_sierra
  end

  depends_on "libuv"

  uses_from_macos "expect" => :test

  def install
    # Reported 23 Jul 2017 "make dosn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8
      set timeout 5
      expect {
        timeout { exit 1 }
        "sim>"
      }
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
