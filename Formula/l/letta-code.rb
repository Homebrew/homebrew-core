class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.1.tgz"
  sha256 "ca0f32da2335d0fd58124f96d02339897d25f2ce060df9e8f744a57e63e27307"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "437b10fc839f66946030861a8f2254f50cb6cb96d2016385da5a23d9ebf70a1d"
    sha256 cellar: :any,                 arm64_sequoia: "d6af2b7b5bffbf9e3aab0ba3eabbef20cd351f0b9973ac67a1fc0a6f623a288b"
    sha256 cellar: :any,                 arm64_sonoma:  "d6af2b7b5bffbf9e3aab0ba3eabbef20cd351f0b9973ac67a1fc0a6f623a288b"
    sha256 cellar: :any,                 sonoma:        "5d96dd5416ee4ce21b4ecc6388aa4913779f82f4f9920c0a6f12b89c0eb89076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b7772a69082ba5eac5163624a2680da955737edd929c5e065d95f91da3342a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4125dd23566c15b82c40e373164a6fb820f952e381914ad0e5460e2027189f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
