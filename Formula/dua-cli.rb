class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.6.tar.gz"
  sha256 "0b7de6cb484fdc0f22b64ac287492aa5989032fe37605e896895f4f9194a47c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b79d98f18379f699ab9c941c4864d7e75bc8f176634f6f1c5ccda49083f07e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7f0d7eba57e327212f18fd1095fe5856cef10c998a5b9a29c84dc1af5c120f6"
    sha256 cellar: :any_skip_relocation, catalina:      "ad3e0288f4a82d68f83f739628956d0b81bcc791e525881fdf18e918f6edafba"
    sha256 cellar: :any_skip_relocation, mojave:        "91bf28bbb3b23cc696831a81b9b4b36cc4e11691b356f188f7606784b1cf6777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b688155b2a88899f4a9c368970068eed5b52de8265cd20b3802d57fc934eaaf"
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
