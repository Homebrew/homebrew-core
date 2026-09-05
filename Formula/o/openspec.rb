class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.12.0.tgz"
  sha256 "ec9737f8211099ef211f9bc7db195fb9a2afe95a52668670b61a5e8d16e1adcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce6851cd61a3cf0e5d46031cd68af50928d974097caabaedddc88e0c31b2c58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce6851cd61a3cf0e5d46031cd68af50928d974097caabaedddc88e0c31b2c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce6851cd61a3cf0e5d46031cd68af50928d974097caabaedddc88e0c31b2c58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f50c066d7784a751cd84f204bf32c3e778fb30eed884cad05694e6ea771cf46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f50c066d7784a751cd84f204bf32c3e778fb30eed884cad05694e6ea771cf46"
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
