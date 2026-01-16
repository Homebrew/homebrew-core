class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "d00317fedff1f0ac3076e427dc090a9b4b1a6efb62f80742ff774447020d4743"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c8215218ae8647d3ebdcab17a355ebb8bad24e38a5592f2aa25cd512d5da54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba926fc01c2afaa2a82eef3fff2bb82f33d2a16fd0495ad3dd46be50b912150e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3afdcf4dda0995700560679ee9fb6de60d756ccacb8b7bb7fc0ab02ca1a5ead3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e2e889c60adf195f21be65624a99e6af34c94987e0c3def041d7ea5b8ff9ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc814152c03eb9db8c5e329f693af029c046d82f69551cd0359c76a5996133e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0dc1fcb98193744be3be3aae8ae742928d9baacbdc8d2fef2f6fe5ea6c2e2c"
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
