class Katifetch < Formula
  desc "Customizable system information tool written in Bash"
  homepage "https://github.com/ximimoments/katifetch"
  url "https://github.com/ximimoments/katifetch/archive/refs/tags/13.1.tar.gz"
  sha256 "57018797a61ab6befb80a0b76cdf7ca457421ef8cfc030fe41d77a78b017fd30"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "katifetch"
  end

  test do
    assert_match "Katifetch 13.1", shell_output("#{bin}/katifetch --version")
  end
end
