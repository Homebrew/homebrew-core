class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "0c135b045fb03c224c26f77eb147a238f0aa74257c963d84f9f9f6dfaad09e09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616b22e45f425dcb774e9788f9c9c8002cf8cc4190bba07a58bfdc61ad06bccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "964bdba80b7e064e36805f696c68bf70d62e22fd98fa3c23326f600bc3d07b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "f41d4b5134fb9104ae9acbc550ad78d01e94b645ba1b758702175d1a1d544e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d7d2f58755e770c196943730d35cfb4b4e19b0e301f7aa346e25596ebfec749"
    sha256 cellar: :any_skip_relocation, catalina:       "272f1b848836a10d2ee5cc954689ef53b887cb563d17fea9e6b61fb39b084c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c728850dd46bdb267f64f29ec0a5bf8cfc6c449bbeaf8e5376edc503ba9825"
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
