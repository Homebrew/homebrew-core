class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "02de8d80347405a876867901bd16539b7d7ceac3095cabcbf9abae3d7da1f357"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "488c81ac144634b38cff1ad55f0c73aba4db61059f4d031eb2d0fdcfb28f2f30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14f1b5a756db5d798fed90a9ea62808efebc7176d4044707e1ae5248384e2999"
    sha256 cellar: :any_skip_relocation, monterey:       "ef6e9675341fa85145aa9564c4fde3269e88b197afb000a5570fa64d5bc6d744"
    sha256 cellar: :any_skip_relocation, big_sur:        "df195525f56cc7989e555596697a623c57fb15b7d95f723684faa92b23339233"
    sha256 cellar: :any_skip_relocation, catalina:       "8581560cdd59fba12b1b3f19c69a0fea6ad4a957ee4691086fbfff66a7b2744e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0bdcacd794fc3b7cfaa71dc3c0204c8909c75b5abf8d57eacaf9ed74c4aa597"
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
