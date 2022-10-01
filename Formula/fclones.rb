class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "0c135b045fb03c224c26f77eb147a238f0aa74257c963d84f9f9f6dfaad09e09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d4b492e5165e30bdbbd20bfc7e41c641d52afef7d0cd70d2abc5f2b4cb876da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecd8a532c9e324e6bf7b014fe05f819a939f6876a6d15124da5c01eb86177c73"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd2b54d44b16d46847d389e47a5965eb1504e3ed4a65e550573823d495c6e1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b91d482a1c02cb5d282c142bd677a08ce6621e7647bba9724d4ac369083397fc"
    sha256 cellar: :any_skip_relocation, catalina:       "9ddfc7e23b762688398636d98c88a7cfb06cd639815bab61a19a97de43013d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4319e0faa7755b830fb26ea7a2213cc404068dfc08898361c8d1b2b34d788644"
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
