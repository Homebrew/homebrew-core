class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "ef283b8a7b97e6b6f7d3a837f73f7898e54beb2689c1bcb6a9e414991b5aee18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9757c153f5fd66c50c3ccdb8c46b5346f6924169e97cc5afba6ef03af6db489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a6050a67febb0797357ea1446ca5ee262d83981347f54cd30810fb0f85bfb0"
    sha256 cellar: :any_skip_relocation, monterey:       "d67489b710d0427aae26c498a220033c27129794d7919c9773e20ad349399ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf766a0eac2d1066e4db114a7f323104680cff9ef3864770e9774d87e35f8943"
    sha256 cellar: :any_skip_relocation, catalina:       "ec97fb73288d226685a0d4415211074d06b971e618ed067dbef3810488a049f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c2815680d3624e307c89c69e21d5ac8722b445d19b38e90201fc70b53bccd1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
