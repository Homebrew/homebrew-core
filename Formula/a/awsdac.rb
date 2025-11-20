class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "7a52b3fe9f8db097652cf72a2f4628f0af539f8ae72c533d4abd197f1a68c6e1"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0165dfdd75e63cef4590052ad3a0993461877f46aae6d2512bb38b452efd0fd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0165dfdd75e63cef4590052ad3a0993461877f46aae6d2512bb38b452efd0fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0165dfdd75e63cef4590052ad3a0993461877f46aae6d2512bb38b452efd0fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "02a55d9a58b5612ff827582626ef0de815ca07034d8fc0fd1ec5124a15f7351a"
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
