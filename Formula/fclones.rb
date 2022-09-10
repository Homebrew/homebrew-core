class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "77281f9c3dead007b427b827cedcafab4ad8de2e6692b2cf67415afe9b817e0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e408a1c73177742571a1fee62907dbe626f89517acb7d017af97dd6332f9b0ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc7f42aacab8536facc6012e9403dab3c8313cd6c086bb25191171225c40b57d"
    sha256 cellar: :any_skip_relocation, monterey:       "5c9cebcf5607ebd55e18bc6a4b87ef6152b6b45dd50125bb8d4d119f9b9c5c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7aa9b7276f36cb8f827af8d4419556344ab0df9d04340929cc6f9edbeb43e0e"
    sha256 cellar: :any_skip_relocation, catalina:       "074641dd55c2124c59ec75c32acea70dcb4e53aebe8612f61b8b58f4b2a1f5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca9dbeb870b74dfaf58154ff3657d5a808e9892100ce8bd870ceac4d42a731b"
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
