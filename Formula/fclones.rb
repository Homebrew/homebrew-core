class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "06ca992499cbe4683eaf96da832a10a39bf6041e102482ea2a25ff4a53195de9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6daf5529b3ade1cceda6a0726d141299f318ca32042ff4a78dba703ad6e62642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f7d9b29974480f397dc2351db35e2ae87896881761d143c7cd6886cf8e41689"
    sha256 cellar: :any_skip_relocation, monterey:       "c01384b6fe2c5ec2b0407343a10404cbba1b232ee07350d6623c98c73cab6df1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbe2a38ada01cfe9a6065de10a8b41020d5f564d382bb48bad0e9d8edc9d5856"
    sha256 cellar: :any_skip_relocation, catalina:       "b768f7ca14b63ecd2cb23f7b7e63516124a6c3141fd0d517ca438e8cd3d7349b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abae545df786b949442eae3f52924b1e8c67ddde405165f83cf5498553fb1a2"
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
