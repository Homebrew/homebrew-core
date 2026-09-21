class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.13.1.tgz"
  sha256 "66bea1499c367cd0669fb1cedb59b1ea88b8c3c7496702e8af5726c0b2f3c5e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50a3b7d70413318d782e331c9163c3f0f77a9c86b47d6ee9aa346456523f899b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "50a3b7d70413318d782e331c9163c3f0f77a9c86b47d6ee9aa346456523f899b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
