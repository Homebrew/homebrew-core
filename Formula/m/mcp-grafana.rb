class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "4fd3452b8c1fe940ec01481d1acb3e41aa9cb2c2c805e4fdb8a2f2f0e0673677"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48d3948eff8940ecc243ba303bac7ad5d0ba2e710e72fcaaf2304bfc82f1f81a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d534edfeb80d3a245aa62426246222e0986568bf441546bd85bc884b8e77f59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab4a99773fabb181662c246d88dc59cb524a7c31c4e156136190a25d0f2476c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b2f21bf8d5512e7fc5521e776bc9278a93a77382bea46fadc06d08e916b3bb6"
    sha256 cellar: :any,                 x86_64_linux:      "030a9b563485e0b878b08712d5ad51244d6af3d1557b0f40b39ac1e03ddbc354"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mcp-grafana"
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
