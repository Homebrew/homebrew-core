class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.6.0.tar.gz"
  sha256 "df3855dee0879e9a25df49f846331710898354d3e99a1ef097093e2115691f6a"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66781ca87ef4ff94ca2156246b2802d36a0eed7cf06d2b32b090efde5e1b0540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66781ca87ef4ff94ca2156246b2802d36a0eed7cf06d2b32b090efde5e1b0540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66781ca87ef4ff94ca2156246b2802d36a0eed7cf06d2b32b090efde5e1b0540"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6099e13fb77fff549b97cea2dededdfe34bca7263d682eee035debfee518042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf2f29283d35830bb8605fdc1ec37d261e0f588b84ec579af0681e38a8ad5d5"
    sha256 cellar: :any,                 x86_64_linux:  "a5c57e2c04f899be56cd38d42230fbfe658a9367bf6adfae0358c14f3ae2acb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output("#{bin}/gitea-mcp-server stdio", json, 0)
  end
end
