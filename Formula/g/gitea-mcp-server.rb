class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.0.2.tar.gz"
  sha256 "29e07fd78b5e149d29ad1638143e5adc1b9a4cb4faf42d8fed0016f9a364b1c3"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed2de6af18e61430e26d78af833600474a974d1f113d52a3b04451477148fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed2de6af18e61430e26d78af833600474a974d1f113d52a3b04451477148fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed2de6af18e61430e26d78af833600474a974d1f113d52a3b04451477148fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a9f90f47f119c57b42ca2d33a4449ad1889b42d00072886f649c05fca6edbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5cc581457e9e871f241d6511eb5dd0582951d78d517c2d912c387ee374d6a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2df7103a36d2fec57f159c9142b6636f6dee0c0a1699807326c26e9b3ec918"
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
