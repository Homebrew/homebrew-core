class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-2.0.0.tgz"
  sha256 "5adc79c42253996ae7b0b12bb60a652880fd55c77a5b08a25f2adad2194327f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93ff671c03690b0804a7ee702518d4ea5fda3d3d7312f4eae436c65712de1a72"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93ff671c03690b0804a7ee702518d4ea5fda3d3d7312f4eae436c65712de1a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93ff671c03690b0804a7ee702518d4ea5fda3d3d7312f4eae436c65712de1a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1080a86ba2fac87023f6ba0e7aef62625d7ce15e0e82f356084909804d53d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1080a86ba2fac87023f6ba0e7aef62625d7ce15e0e82f356084909804d53d912"
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
