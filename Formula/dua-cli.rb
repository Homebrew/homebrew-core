class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "0012c85fdd65eb2c53066df6761864d3ade8c63bd82922826185eff3a40f9e16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ae0317e5df332baca066b6bba88094ba9977fed34c408775a789dba07227774"
    sha256 cellar: :any_skip_relocation, big_sur:       "47b2d8ee9906bcf7846572ddb65f7de5fd9c3267c4434a775e8e61e5bf2a91e4"
    sha256 cellar: :any_skip_relocation, catalina:      "be7b296e0176be9a512b8708da428f77d31f01c3e644f955d0b593d7ae813751"
    sha256 cellar: :any_skip_relocation, mojave:        "6db05f74eb9753ab9662684f74369ec1071d48a2a4f021219b6cddc141d68f2f"
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
