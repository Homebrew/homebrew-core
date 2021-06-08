class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "2af2408eecca4a1a04d0d395322f110b97e49d5366eb435e2e0e36b8b92684bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbc7bf54c041662ad6277c92f4ace847c89e084f1493853bbaaae8b8bafb53ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "c77b5a80ffaab3c8d38887b97ec16ae3b233f39600d6570ae50df73bb6ebeb4b"
    sha256 cellar: :any_skip_relocation, catalina:      "866d9ae203a3e911cf9401316679677137550e83dca48524cadf8ae84e49e52e"
    sha256 cellar: :any_skip_relocation, mojave:        "8f34c2f38e52f14f72a7561fc67f496661632b67d00d9c10eec8d2ae5a93f630"
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
