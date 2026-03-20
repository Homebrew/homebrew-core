class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "9489cde2f3d2fce8d6c16cffeddf75f774812f07d8b91abcdee804c250353f77"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29197de10502a6663d195fd14ebfb90081a65aec72c62f4d18a6e4e449478603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d77c26ef1c595d63d1265ac93646629cddb8bc11e11e93b2291d88f4ecfd1f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56fa7e378ca5796642d487d3505e0529ce84bfd9154f46400a4ff05ff3db4a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f44f5d404b80f82942442fd7a346f202381bd68cc29740a9475f55f7fc6dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5efd1f3ab3e267dbac2d62308c36dcb9b93ac161ddd3d2d5e197b2fbdae54f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebdd99c3ceff115f30e70292edef4d4eca9124f35b3fe5c2484d0c3b3ecac41f"
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
