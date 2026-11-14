class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.16.6.tgz"
  sha256 "9b701b6522d3a513db99eeb7fc4f04cb261fbb08487645209482eef4408a529e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e6febb20ea3011171dda78de4337ba9239e8e028533ed9d005bcfc00ce39c37"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end
