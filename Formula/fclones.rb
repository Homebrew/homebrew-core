class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "06ca992499cbe4683eaf96da832a10a39bf6041e102482ea2a25ff4a53195de9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad62a9a17a5a75fc3bd402e6e829921acb4a3d3e6a09bf35ba7a943ad1b0a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f806c3113c108f4e8e09b4b29d1128f1733f790240354ac614cdf40ebb309f0"
    sha256 cellar: :any_skip_relocation, monterey:       "730802a0343d1d42a2af21526707212a882c6216aa8542215b0370412f696cc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2207ee04d71201e57dbd636adc30360711c545929074632d37564332f817a029"
    sha256 cellar: :any_skip_relocation, catalina:       "df529756c33c4fd363f8305d2cf6d35f95cb699a7b36d4391b5dd1aeeba9f873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337c61dedd3eeb8517f62f9cafd9f306ad0bf845c047a4ee57416faced593173"
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
