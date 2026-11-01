class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.16.0.tgz"
  sha256 "3d10a685a350bf46f2801452411617b8d46206c77a9d86ddc95c0ddba4d7480b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aebe9acdb9835eeaa14a366fa3a2a552ef24f3e9edd78941984043188be4a6e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aebe9acdb9835eeaa14a366fa3a2a552ef24f3e9edd78941984043188be4a6e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aebe9acdb9835eeaa14a366fa3a2a552ef24f3e9edd78941984043188be4a6e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10fe156eb57b772eefcdb9f6daa2b52a8a1dd4f10aa3adec065c87f2f6e16d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10fe156eb57b772eefcdb9f6daa2b52a8a1dd4f10aa3adec065c87f2f6e16d6b"
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
