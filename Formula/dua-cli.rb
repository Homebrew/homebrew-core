class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "6f9f6cec267e77ad29254aad0d5ee2e25443ad51e37ebe10eefea2cd239fce12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44f19b8d7258b2204cd88ae751ea1bcd935e2b10ad06c250cdc38c1adf5a0a9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "814283274f63c5eba8a3a980cd794d42ade7c0f58ac548dd14c01e1314af512e"
    sha256 cellar: :any_skip_relocation, catalina:      "8a0c9bb3951448311e6d86daf62081c1d2ec5adbc1c448970cde2709b47f133e"
    sha256 cellar: :any_skip_relocation, mojave:        "a892cf84d67c6697695eee33b6e36297d19afe8358f1c3188e36642e341ed600"
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
