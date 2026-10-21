class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.1.tgz"
  sha256 "45aa7ae3c2ad1b51383c1ddce67f6fd26efbbe6637669e8f4597abe37bb87c05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88cc89efdf00be8f47c14a975c62f4a5799b3a8aac1ef2a9eae88ad7b1b104ee"
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
