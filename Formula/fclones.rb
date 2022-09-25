class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e8b17c90f1c9d5d501599af4eda739f24a60dcbc1a2f61cdf6bcb6d89291fb6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91cfb43282e8d48fd5bd80d9164aabaf88cf38280d1c2dbd0e7168b52cb259de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "272d493e352d63ee4425729274e5521fe0f9120ff7fe6c09cfc82ab797b77b43"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b8e8ed756adcffe131ccc5d2a4e1885083909d3b0834dc0cabe9d4ebab3453"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8b5b15e3000f8515faad807556a0d7c52e9196ceb36f5fe93fe22692941860"
    sha256 cellar: :any_skip_relocation, catalina:       "d3c221b00a6725076e86251162f29711eaae8200e918deeeb0fc9ed88dedf98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4f18be9c62595c1b15d8ca7a04d1e21afdf697f40e26536eb771e8e1e1e978"
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
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end
