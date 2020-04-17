class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.1.0.tar.gz"
  sha256 "52a9d5ddc15c7fb227c87147d991bfabe2aae1fbef8169893a9111dcd3aa641f"

  bottle do
    cellar :any_skip_relocation
    sha256 "90050fb3e32743d9d3f2ed89e04942b11996d1de1dbc9cf16ac68d0556b1429b" => :catalina
    sha256 "2f0e00fd6bcea11069e26d0079dc326b5111319630c54132816f401d532ddce0" => :mojave
    sha256 "3d31d46adb5eb71ee68095f80e619b4890eff95d024be8934bd27373ed6de12f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
