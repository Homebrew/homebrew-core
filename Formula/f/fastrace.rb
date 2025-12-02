class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://davidesantangelo.github.io/fastrace/"
  url "https://github.com/davidesantangelo/fastrace/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b8c79571191266f0f3ef58033b24bb27c81182bfd4f99cd868e778e6876b08bd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfae68652addb2f41a3fc7407753cab2bcdb2cd6090be188624e3335a3f9a646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe9e27c6eb426ec19f41d1c26503bbf5789bcecf00fc4c08bf6b3c243f1cf8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94d34eb792cd5c4d26629106fb3829e1543caead8e9b54e04a6ac752c63c1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9507c6ca27c69d979d54c460c5cf9847d20e243866834fe8be059e357f903da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f70756101d9fcba0b8e04dfbe0b7a664f9b9b805c6da4baddee560b6a01ef2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff00a37ee60fd70ba5cbc31fb5457d3fb026788864c90bb7dfa134ac5fed710"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end
