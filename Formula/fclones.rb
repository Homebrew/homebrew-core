class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "23aabf22cced96ea25a28e1a1817bd62502d28140c3a9cf046d951accef5125c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4bafb7c2df590dcb840f25ceb9b2af4007d14b23102bb6b8b97acd7ca06041"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f03493f4f4b69ee2a417a3971bd804d607cb21a738002e9249e304a555624d53"
    sha256 cellar: :any_skip_relocation, monterey:       "5237ca1a8cf7725691a05001f82317a5b5ee9df9f1b0291e69552e21ec365be7"
    sha256 cellar: :any_skip_relocation, big_sur:        "30555e6e952ead488a4f6e8274481299e4e10fd407abed510df727fd5f356881"
    sha256 cellar: :any_skip_relocation, catalina:       "4eb97490c09c32843867ad6f4283240cab6442e925e7ca37b419e233fce5ef16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0e40ffbdc396481a86549da3875f0cdd646f09c340fba09a1dae29a733e429"
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
