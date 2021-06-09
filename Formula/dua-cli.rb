class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "0012c85fdd65eb2c53066df6761864d3ade8c63bd82922826185eff3a40f9e16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "446104ccf0859d02cfd5c54ff77c16e4e36243902b12e3b5f89add68ef9f3827"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca4f98add4eaee39ad3d1f6e3aa8c4359c739da3877f567b07c9d018774dc9c8"
    sha256 cellar: :any_skip_relocation, catalina:      "8f237c54d9e7287884ca08bd0f5db7dfe605c2a22cdffc1c195d6a262c324ceb"
    sha256 cellar: :any_skip_relocation, mojave:        "5e2d79061e2d6bc6aa03f1d928fff78055d2ef1f48161429fed763b28b7bbd44"
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
