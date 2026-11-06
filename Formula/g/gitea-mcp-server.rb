class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.13.0.tar.gz"
  sha256 "7f4a2ba841673ae31c8e48003f1ef2d0a5034f8e5fb734e3e57d9dedc3bdda8c"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a48c51c993e8588effcf9eb7f3bf32633173c6a7d53026751fa1aa9f8d201e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a48c51c993e8588effcf9eb7f3bf32633173c6a7d53026751fa1aa9f8d201e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a48c51c993e8588effcf9eb7f3bf32633173c6a7d53026751fa1aa9f8d201e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "346c92ae014275047b4d3eb16919ba61acde34cec9c4bd9f390de7907e5227d0"
    sha256 cellar: :any,                 x86_64_linux:      "067f5132687aebb97f73ab147bf864a1f2ff029bb91478fee039e05d1c56e74a"
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
