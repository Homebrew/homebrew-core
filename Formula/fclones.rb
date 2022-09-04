class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "f90e96e13789ea537efc8d68eeb567dc669965d3624f71558b3d3a334b3c4837"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7b013d29ff3d10b512b3a8d78516b9c70cc3b8126f462d61231a7e7288d105"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfa96f05b2179a214399ebb2b2889fe4b2f2a02479ced108f5e3a57162a0be9c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9726dcb4bfb14a5c4453929b89991c50ef3a7efe38f212531a3bbf7733fafa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4292ecf8b26d650dfad1b0d5f90f46d645bd5da474fff75be81db96e29c20dc"
    sha256 cellar: :any_skip_relocation, catalina:       "710bcc218dbdeb9eb5405811fb1a08fdb784808aa79b19b298a479d1d0ea824e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dab8d4f3adccc9cb325a5638c4646354f4125a17f0a28eee3aa3f4f431eefc2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "a9707ebb28a5cf556818ea23a0c7282c", output
    assert_match "16aa71f09f39417ecbc83ea81c90c4e7", output
  end
end
