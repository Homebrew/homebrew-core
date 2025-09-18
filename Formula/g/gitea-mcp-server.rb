class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.4.0.tar.gz"
  sha256 "a1708fa8a16786a592e09e84f7f4863e033a692e50bd4a7a20781deaa6b633c3"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f72c421e386fbc4ec3038787aac700f8faa19f861a1f25a54781d06bb63230f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f72c421e386fbc4ec3038787aac700f8faa19f861a1f25a54781d06bb63230f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f72c421e386fbc4ec3038787aac700f8faa19f861a1f25a54781d06bb63230f"
    sha256 cellar: :any_skip_relocation, sonoma:        "41837172b03d3b7e56f47a6b4ddfb360c626be5765392008c2eac6e245f78066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47d8641e2c8430649ca5a7c609b95ab88ba676ce46ea66fdfcc7a5606a98163"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output("#{bin}/gitea-mcp-server stdio", json, 0)
  end
end
