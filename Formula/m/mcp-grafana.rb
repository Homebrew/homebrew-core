class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b3f909d701f83f751c26f73f84135cab0749c04093c69d25adf3f902d9f95ba1"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ca8891135475bae553b1c90921c519f477f46b82bd98cda81343211c20f7b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66b678018c962ab80caab5023cc7c43139bdc192ee8d022dc98def4c2f2a341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14afaf80ffcb1262794fa8e35bdc1f43c752d5bce2b128eb5d4908347b27bcc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc34c55ef145c16420eb83e6f0e15e1b2f331ebde2eb93bf59053e3ce656b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cd10a3a45f3d433e2470bddc553b767f9d63a01b64537474ffc4a3560cd1634"
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
