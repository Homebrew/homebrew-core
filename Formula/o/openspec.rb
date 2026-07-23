class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.6.0.tgz"
  sha256 "a80477767e98a62e956464ad09a44b28cacc4fcbfde23765f7b4ba598ee13859"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89332a86193cdd004b2513803b03a15c5acdf6d66abeecf0f05f860496652bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89332a86193cdd004b2513803b03a15c5acdf6d66abeecf0f05f860496652bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89332a86193cdd004b2513803b03a15c5acdf6d66abeecf0f05f860496652bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fb999014b3b3abd013838013bf5d38779ba6a0fbbed4b4dd853e6f4bbe4505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78fb999014b3b3abd013838013bf5d38779ba6a0fbbed4b4dd853e6f4bbe4505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78fb999014b3b3abd013838013bf5d38779ba6a0fbbed4b4dd853e6f4bbe4505"
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
