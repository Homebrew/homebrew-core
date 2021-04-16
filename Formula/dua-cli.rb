class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "906a2c1cf5b19247fe1af92fb0bcb844095af91015341f04816e46c4b7b69872"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f43fdadeeabf46c7e7cb7b209e4cfcc96bd29e3d1dee7b0ef9bbbca0eebe102"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6d58b3a2af258c74c614a61ad6c3c3775613ce42b5cb5b6d27218d59698f975"
    sha256 cellar: :any_skip_relocation, catalina:      "116d93f67866472620cae7dc477d9858723b6efd763def40825862856ed5a196"
    sha256 cellar: :any_skip_relocation, mojave:        "dae832906bd8be5f001f5a7ed2ee271aef6ec78ee761e85d4576a3693285a30c"
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
