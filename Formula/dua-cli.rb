class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "2c247fcfccc2f4bceb7746e038ea897d2f2e60190bead380b0dcb7a1e2d15b90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860306b9c9d2ce3425097d24870feaecac2d262a572dedb2c0572853f71c7c06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e23c20078566ea51ebd2f6fbd1d0707e9c4d323e2912c49d921b482f006bae23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "530fba7665685055e64fc22d293c99988c98cdda45b43f9f074fd734e1cd9d82"
    sha256 cellar: :any_skip_relocation, ventura:        "15fcf23b3fb6db49153e0db409d09c33e1741cca8c9d50c0d2b57597d9e6f679"
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

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
