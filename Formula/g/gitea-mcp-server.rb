class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.10.0.tar.gz"
  sha256 "6cb7f69018160ff67f89f9f5fba5799be8274e75fecee03869be21cc5c528d92"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e287845888fc01b28d67133b182b4a0a10772269e9ce9f598742c66fdc3b19c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e287845888fc01b28d67133b182b4a0a10772269e9ce9f598742c66fdc3b19c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e287845888fc01b28d67133b182b4a0a10772269e9ce9f598742c66fdc3b19c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b61328fd978dd1eab2044cc2b2299e575ecd972ac5829db13a68c8cb32d4489f"
    sha256 cellar: :any,                 x86_64_linux:      "472206e3c20ad31242b605047c8cefe6f47f6dd5577a4d62b6c9f74281c7f375"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # Read the reply before closing stdin: 1.7.0 exits non-zero on EOF without flushing
    output = IO.popen("#{bin}/gitea-mcp-server stdio", "r+") do |io|
      io.write json
      io.readline
    end
    assert_match "Gitea MCP Server", output
  end
end
