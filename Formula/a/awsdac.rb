class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "fd2d5057ad893c73d38e50e1709276cb58ad69a2f697c024d859c815ce5a5183"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f49a54a7f98dc6da701b19cffced8ef540412eb6cc38d0ddec62b2c9a9b144d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f49a54a7f98dc6da701b19cffced8ef540412eb6cc38d0ddec62b2c9a9b144d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f49a54a7f98dc6da701b19cffced8ef540412eb6cc38d0ddec62b2c9a9b144d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f49a54a7f98dc6da701b19cffced8ef540412eb6cc38d0ddec62b2c9a9b144d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c12cc709c92e665216729b3133e530075c043499d45779c69d7a439eccdecd"
    sha256 cellar: :any_skip_relocation, ventura:       "46c12cc709c92e665216729b3133e530075c043499d45779c69d7a439eccdecd"
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
