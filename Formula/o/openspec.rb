class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.16.1.tgz"
  sha256 "8ec4b326a065e104461251ec508e5cdb38f753b3ba83949c2e3a6416ae57fd9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfbfc1769c0664072079e04b5e091369fe5dd1508234640e2e03dc0971c1127e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfbfc1769c0664072079e04b5e091369fe5dd1508234640e2e03dc0971c1127e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfbfc1769c0664072079e04b5e091369fe5dd1508234640e2e03dc0971c1127e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de7a7a7f3dc184dc4883cd1b7e635f6bd7cff2f0febe208327623d73fbc6ef90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de7a7a7f3dc184dc4883cd1b7e635f6bd7cff2f0febe208327623d73fbc6ef90"
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
