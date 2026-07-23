class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.4.0.tar.gz"
  sha256 "1a0c8837a415721780954d09a72fb93b9f1b5af60cc0e2abc4d98a87f61c09a3"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56df00137e65fafcba507c3cc3bb92522bfb31bb83c08a44bf44a76fd6fdd750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56df00137e65fafcba507c3cc3bb92522bfb31bb83c08a44bf44a76fd6fdd750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56df00137e65fafcba507c3cc3bb92522bfb31bb83c08a44bf44a76fd6fdd750"
    sha256 cellar: :any_skip_relocation, sonoma:        "679043d9c838f1284a61aa2c1f6362345c5b45d7d03608ad1fda396964a1da4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbbd1b5ada5809b542f2b0de1a1bc67c7012ccfd27945efa9582b28c6ec98da3"
    sha256 cellar: :any,                 x86_64_linux:  "a0151136470ab1d2ec427801ecc3341e53fa1264c149918023c06396f07cba1d"
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
