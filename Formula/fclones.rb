class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "f1b79ef82140b4a09403ea9d5616d853684a08a163db2c7c62f437f266aa4177"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a40ebe6b456bcd3c453acee8782b45a1c938f79fdc15a899a5e9a68ad28b68df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b52e31ee371aba9a36cf0901a3b9d653976726f6f6d530c437e04901b291aae"
    sha256 cellar: :any_skip_relocation, monterey:       "b01898f45a81dbb32284647e57bba47faa42b3955e900db52912d19c2a283d3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce95b40bbd14f2495cf87899ab0329db00fe52da24142b31070a67e7f6cb952"
    sha256 cellar: :any_skip_relocation, catalina:       "d7c6eb71f74148765e7df38480bdb7159f1df5c263b8a8ff570640d3520983fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b500d8a8656bce36d07ec9a7a3adf4a47724df443ca160c308d59c405c127e3c"
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
