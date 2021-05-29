class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "811aa74f173468e9a69ab2df9cc65f7b9f6b62cf20b7829bf1eaed8989895046"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "948f7263ea8071b961164b5d09672f8678a4fa6d02ede3cd0514df2ff60bbe16"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f6a1e7737f226b7ae75c1686fbd105683f2538c0a3e22cfd0fd07e547055481"
    sha256 cellar: :any_skip_relocation, catalina:      "6693cd8df2da8e10b7c896da80fba6f0066d186e61072f4a4942f6ca11b2ba7c"
    sha256 cellar: :any_skip_relocation, mojave:        "69249438072866f078bf77380f98b8f61050fdef4e18778562657f507ac4204f"
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
