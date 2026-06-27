class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.29.2.tgz"
  sha256 "ed0d89293d51b7adf19033fb8268b30722afa51a215524aa698890a28bc3055f"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "02c7efc1d78de628a7bbc469d378273b9d40d9c86d8448f54dd4c6da2ab7f691"
    sha256               arm64_sequoia: "7d473a8459b197119bc79f48c741e1c0219b7cdc430b4a40a76264db76cd8cad"
    sha256               arm64_sonoma:  "eb03bafd034636a25948fe895d56bfdbe2b5ea99c64595ac0f9787f91accd462"
    sha256               sonoma:        "baa9001b73237217650d1d72d7d395d9d316d31b0a3d9eb486d9836f1095f795"
    sha256 cellar: :any, arm64_linux:   "1bde77cc1bd112fafa7509f575e4534f37da00b0692057972b882e11d7ab039a"
    sha256 cellar: :any, x86_64_linux:  "6d6900f3318ff578f8d8757779df4e64aa767d1fd6966b26c3b506d4e5d13c45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries which were source-built via script
    rm_r libexec/"lib/node_modules/claude-code-templates/node_modules/bufferutil/prebuilds"
  end

  test do
    # TODO: recover version test in next release
    # assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
