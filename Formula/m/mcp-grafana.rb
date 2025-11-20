class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "08d41a96849e2f5751a0dc625958e2523626285c8a0afdde1c40d4357b93a1b0"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5974a7b990bfa2f02a812d2189da9d5f68c3233620a5d07b0c8fc47b05541f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ce22a36d4234ec3daa8f443709d7249d2e0718b2832438712a157fbda062d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47fbbdd5639ab04307d689c15404309c14b4027f01737473a87290e659d27e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82c16de22ef1d24b516249919627fd295c64cc961e467913279907f10d3f784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633d6f483caa2b8ecbcfde98552619ed13a6db075e30b9f2b2af27ea07ee550f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f923e5ec29cf1a86cb4391cefbcdecf31720955c17e8a6212b524787c83bf0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
