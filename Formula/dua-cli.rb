class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.6.tar.gz"
  sha256 "4c5ad60b3a9919fa89736431b7d1050ef9c3acf19d29b2c20fb85d8106872a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c48a9f997eb8b7a9a02e06868e71f70286aeb7ea25b6488f754875fe91863f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d413a35609bb5c2f4be406856ed47c157cef3fa725178136b2185b8a66eb7266"
    sha256 cellar: :any_skip_relocation, monterey:       "eb20875584fecad65610dcab605a331fb470ff40b632eac67efa944b011600c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b4dc1005bcae2e97de60aeadf0ac194b8fb303b83d6f1ede7bcb4400063435e"
    sha256 cellar: :any_skip_relocation, catalina:       "8e13a660e026762742f43664df6b8c31539bde5073554884e950aa19b617cc11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b2995a9a8a384efff3715da0aa91bc863b682da495216ef41c42bd765e7cb2a"
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
