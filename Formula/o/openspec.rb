class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.4.1.tgz"
  sha256 "c039b617a961499f49466791842619189998edddc8b05cfedb22c32142a0c77a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1372e7d8fb0880873aa7968463dc0cd628bbe459a67ee7faf8842d64965f22c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1372e7d8fb0880873aa7968463dc0cd628bbe459a67ee7faf8842d64965f22c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1372e7d8fb0880873aa7968463dc0cd628bbe459a67ee7faf8842d64965f22c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c78fa9489b310cd31572779fe46257e081f2734109be98129f739c1dae89231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c78fa9489b310cd31572779fe46257e081f2734109be98129f739c1dae89231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c78fa9489b310cd31572779fe46257e081f2734109be98129f739c1dae89231"
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
