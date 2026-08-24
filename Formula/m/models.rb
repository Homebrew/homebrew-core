class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://github.com/reyamira/models/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "668c931304d80d95aac4a2bcf3f85b6aa3e1e1a457901c943a16f6d7df6230cb"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ee53e5a1374c1762ec864bf8f1772e688cfc6a6488539c113eabdf46548bc06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c115a0e92c715e55732c8b6dde0d1e573f19441f7af77c32a8e6bab719d59a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd24f45ae54d697509f05f4d8864461aba6153c0a3fba8f3d13a0d9b9656b230"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b1b9a8027756f4a7da9c5ee02ee87bc1eed52e1902125e069ed0f3234153e3"
    sha256 cellar: :any,                 arm64_linux:   "c445ac8d4fe8efc4e7cc081a021d330dc1e6ebcc7bb20ba840a45b9835173fd5"
    sha256 cellar: :any,                 x86_64_linux:  "29cd5630d61efe290e089c8964f1424b8c5d1fa0d4369e2e5880cf15671d4d7a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
