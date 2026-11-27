class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.17.1.tgz"
  sha256 "c582f826f1442fc9e7b34440ebb86741e8aeb5a197a239a397bd7204a4b1e1f3"
  license "MIT"

  bottle do
    manifest_sha256 "82da5d4def4cc56896ce73fbd3ad26ecac125d9d4b585e842d3ad0a285a25af9"
    sha256 cellar: :any_skip_relocation, all: "fc8bf2686253023d01b2c85a73be30ee2475cbff36c6d2fda91897ee1e794850"
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
