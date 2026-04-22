class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.23.tar.gz"
  sha256 "df8f9ca155ec84e26db6f2060b20cda2e2d5b81d990ae96e7b26a006bee8fb33"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2148b86ef64e6cb6dbe77a810cbfad514c751abd75f1853d50658c94649bf384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2148b86ef64e6cb6dbe77a810cbfad514c751abd75f1853d50658c94649bf384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2148b86ef64e6cb6dbe77a810cbfad514c751abd75f1853d50658c94649bf384"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d67de9c136c5f50e24a0dc6ab275b80fa891684139f2d546a609f355813161"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"awsdac-mcp-server"), "./cmd/awsdac-mcp-server"

    pkgshare.install "examples/alb-ec2.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsdac --version")

    cp pkgshare/"alb-ec2.yaml", testpath/"test.yaml"
    expected = "[Completed] AWS infrastructure diagram generated: output.png"
    assert_equal expected, shell_output("#{bin}/awsdac test.yaml").strip

    # Test awsdac-mcp-server with MCP protocol
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"awsdac-mcp-server", json, 0)
    assert_match "Generate AWS architecture diagrams", output
  end
end
