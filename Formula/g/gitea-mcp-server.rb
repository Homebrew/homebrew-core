class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.7.0.tar.gz"
  sha256 "deb3d08596f1e29da26d9e0a535482d953c41f4e24f2109d94fafb562e7683ba"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de9e4c6407ecbc5312da893c5c872931800b17ba2eac135407279520644eb0f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9e4c6407ecbc5312da893c5c872931800b17ba2eac135407279520644eb0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9e4c6407ecbc5312da893c5c872931800b17ba2eac135407279520644eb0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0a47c1500fa8151237266619e232691f04a675879e497cad19bb026e02b3b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c255d45a8414b6ecc04e1fc056eec19f829ccb00ee6ca56392a81d4f4cb320d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71174d341bdb94611a537171aef12ff262a9cee7054712199eac118d484bd09f"
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
