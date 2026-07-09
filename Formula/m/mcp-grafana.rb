class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "bae7104e2ca4c4381b2dd753309b3a0ce4b2256df0fcf43e9982668e3f69c4b0"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9764a9c091d1e59c7fa140654bed0145f57168035bba51b953c8c39cea96648c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7741c19231ef437b9d27d470c40e796c1b121f6749b21a942d0615653434879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a2d1be59212d7aa2f27bf9dc291165e36a740b4f4b05957da2d47743d9e096"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d6f56b02e04f820b701f9783dbb77ee6d3907fac4d5f33eb80266055bce31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f38b92e2954a4d51164e00208013080afb3a558b6b932339513e1d31922ce4"
    sha256 cellar: :any,                 x86_64_linux:  "61a79374cb9955dfb7f26fbee6c3d027db75b00dd480319aa5ac870eac26c3a2"
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
