class Jsongrep < Formula
  desc "Query tool for JSON, YAML, TOML, and other structured formats"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2467abc8e7f94219b70b5fd99a3a28937ca442721f1967fc910e3ce64dd0515c"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2270c46faa7bf96376c94c17fd1d082331aa13481a2e2cf990f662b90d4962e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a64b2104bc9e6a29df9e9ece2e68e3b19d10f93ed2deed7887d181f1c68a5d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aeebe70980bf32c52f3168cc8a59357964bcd54e2ff7f611082b5021d8bd7de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7f22f19d0c8e48400a2cf06415f5503bd1cebf2cc9dd6ff9f40da0e9cf9b1704"
    sha256 cellar: :any,                 arm64_linux:       "ea334655006e48a68a91a1cc14d13b62b41ab62f8a8bd2667c0daa748de09541"
    sha256 cellar: :any,                 x86_64_linux:      "30c37b071c068beed522c514fadb4f78d8272f54a0693c11a5fd88c9dd6d2ff7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
    system bin/"jg", "generate", "man", "--output-dir", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
