class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.16.tgz"
  sha256 "1e451ce1049ecf5beed9a0f023d51997c7bd0f9868e85b1dfddb9a5b875d8cbd"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "89ea850049a4b5e93835fee04f8f514e2067abc2d96e78b77b7b5cbf5f9d6a72"
    sha256                               arm64_sequoia: "df4b5909b2960094bf7de860db0026e658c6e8e95dc4bc3b0c929764f0d8485a"
    sha256                               arm64_sonoma:  "68e3dfc642889dd58f4fe14fb28f37e6db35739c6c258ccedd60dc28eb3cb9ad"
    sha256                               sonoma:        "8be670a369dae7c932c89872ff86771546af9a37295dd09a0d9502d3aefc64bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6760692850624d16d3d8e459bb980c302b10c3f1e92ebc56ef37b2412a978b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f23c13041200633a214b50aa243618d0fac55bfb7509d0fc3293cdef9dfd13b"
  end

  depends_on "node"

  # Backport cli-tool version metadata fix.
  patch do
    url "https://github.com/davila7/claude-code-templates/commit/55b8c382abc412180f2c30c07644c5b2b5d01892.patch?full_index=1"
    sha256 "30cc5661d33eb67dbf1981012c9df873b52006c3929ae9fdd37d1c6b0955c16f"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries which were source-built via script
    rm_r libexec/"lib/node_modules/claude-code-templates/node_modules/bufferutil/prebuilds"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
