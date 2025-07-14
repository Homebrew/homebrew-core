class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.1.tgz"
  sha256 "5e8918b25f5c7486930bc4cfa6d0df18f94a4f1d87e4f20dc8f5ed533a217a4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ba35c13047e7244817ea1d5e33195e3535e894b424061a1c261a0f16a7346e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2ba35c13047e7244817ea1d5e33195e3535e894b424061a1c261a0f16a7346e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2ba35c13047e7244817ea1d5e33195e3535e894b424061a1c261a0f16a7346e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf3b0623c35bfa1afbb727465e0bd356c1c5c895c3b8ef97e5cfa79110db42e"
    sha256 cellar: :any_skip_relocation, ventura:       "cdf3b0623c35bfa1afbb727465e0bd356c1c5c895c3b8ef97e5cfa79110db42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ba35c13047e7244817ea1d5e33195e3535e894b424061a1c261a0f16a7346e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ba35c13047e7244817ea1d5e33195e3535e894b424061a1c261a0f16a7346e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
