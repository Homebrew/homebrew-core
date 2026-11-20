class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.16.7.tgz"
  sha256 "5886c7cabf92199e4dfe9aa0f7cc5518d16e7907dc4b3bfcd7882874f9934582"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc1ffb9e18a23d86b8fb4835b4b133b61f270da4f8eaf463c099487e034dd832"
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
