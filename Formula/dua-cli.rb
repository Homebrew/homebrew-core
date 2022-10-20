class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "ef283b8a7b97e6b6f7d3a837f73f7898e54beb2689c1bcb6a9e414991b5aee18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e23c20078566ea51ebd2f6fbd1d0707e9c4d323e2912c49d921b482f006bae23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "530fba7665685055e64fc22d293c99988c98cdda45b43f9f074fd734e1cd9d82"
    sha256 cellar: :any_skip_relocation, monterey:       "47b184df5117dfa26c75d6dd57ce386d9e9bbe13305aae4002612d92986e59c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0df98778d08d57ac4e620553f4b1fcef6f77219edecaa46a247fa0f53297ad8"
    sha256 cellar: :any_skip_relocation, catalina:       "5b88c97365fb59958e6e3442534f6c0129c50132fa6d4e0475b4366af08a41fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e2c40bb9a9cefffca962a6dc8fe2c01a4143835831fb8369d59331be197cb7"
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
