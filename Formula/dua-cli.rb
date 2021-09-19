class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.7.tar.gz"
  sha256 "a7fe7710e2191ea41a77861fc8e0fccf24ef4b597c5531ffa189b17f6801dc9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8923cd1646326c673b4ca20088c80ea0c587628e43d46424f9c59513714a17b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "504ada084b61ba06a5117027950ce7124a100285414f8e342f61704c5e775e3f"
    sha256 cellar: :any_skip_relocation, catalina:      "fe333d8aadf59a44a6f72166d4f60eacb4b36c8920b369c0c8605ac665f69015"
    sha256 cellar: :any_skip_relocation, mojave:        "ccc0aa70b2ec1e1068b5253466841daa5e1b7b62767ce2b80c5c86a5a9762d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2be28c11b363fcc6e846f5db33270ea7890834e19703fe093e8fb9c8b8455b1"
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
