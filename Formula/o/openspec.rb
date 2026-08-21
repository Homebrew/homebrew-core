class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.10.0.tgz"
  sha256 "fefcf1b7d1e38cf06a3279c6245170dcb0d261d8d6c8ead3f3096b41f4b971fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0f7b8373e4db514eac4a6ca2ad4a0185780a525a4f74906e134a561e8acb17a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f7b8373e4db514eac4a6ca2ad4a0185780a525a4f74906e134a561e8acb17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f7b8373e4db514eac4a6ca2ad4a0185780a525a4f74906e134a561e8acb17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "735b3e3d9ccc1f0a37fc20b2c590729f22e7823d928547a8b64bbfaab09683bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "735b3e3d9ccc1f0a37fc20b2c590729f22e7823d928547a8b64bbfaab09683bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "735b3e3d9ccc1f0a37fc20b2c590729f22e7823d928547a8b64bbfaab09683bb"
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
