class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "a548977699a13f2a584d318edbc46cb42f9f7e5badb645cb886389a9669fb734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df733c392981eaa0cf8d582cc99d29245e3e010a493a00481c67bae3fe1c5412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1392a2b4b2790060e4dd1a84e72a4e4c94c345715e29ba0bea4b2832bc707188"
    sha256 cellar: :any_skip_relocation, monterey:       "43704146c83458b79d04440a81c3cb0975e9ccb2bc58b76bd4abc7494c91c153"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b2f8b62b36d4c1a2af43364eb44b355b711d294236457ba1d4778c39638cf42"
    sha256 cellar: :any_skip_relocation, catalina:       "5097b69ff2372281bc74a00694f19e172fc5a9ba1b69c9252dd007ad2e427b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9a02c96cec3c64a4227167cc9210fbe2969469c53a93774e2f709d4211b7d7"
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
