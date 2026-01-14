class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6ad6418c5e8fe4ec97e5e1a8bd0e93ad76072afe42525cb2af2d6ffcd80affac"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a09b13d5f32f169254daa35971cdc804f4d85029c19ba2a2ee778b6520c4a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac172c5b78f304eb18b39e325e92691082b9a93ca20a18ed03bf9260db67aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33efd70bc687c68d60fc36788f685631b2f312e9422ba00df180fe6ef6c6d112"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d20910ef468bd49b9c9a6e24dc17cbc89c6f3c9136f985925bb5cfa221b9bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11004f65c7fe2fbbc574c50a004157493ab8d70307f59c65cbaeafe67d18fe95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0203e30e61897fa70beb498aed0585ccc801ca3b3195d98234f79084ff5322be"
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
