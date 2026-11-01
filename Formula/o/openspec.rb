class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.16.0.tgz"
  sha256 "3d10a685a350bf46f2801452411617b8d46206c77a9d86ddc95c0ddba4d7480b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecc673a89a3a360aac21a6519104f102462e02d887442672e673df120d051a49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ecc673a89a3a360aac21a6519104f102462e02d887442672e673df120d051a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecc673a89a3a360aac21a6519104f102462e02d887442672e673df120d051a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2ef6178af8af18a18e811568ddcd1e04bf781f965802c550575fb98812429e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d2ef6178af8af18a18e811568ddcd1e04bf781f965802c550575fb98812429e5"
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
