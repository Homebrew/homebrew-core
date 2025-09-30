class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "950297134457eaf0e78dd355b2642469fde354bda761f250c4a1590727b33766"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73a12d58c82ff2348b88ac00f9afa122e3825b7eec63116d417a48f84ae2b094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a12d58c82ff2348b88ac00f9afa122e3825b7eec63116d417a48f84ae2b094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a12d58c82ff2348b88ac00f9afa122e3825b7eec63116d417a48f84ae2b094"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3eac868c26287de87187b517a6682eb2cf57771c8f4201f68332f603d2bf8c"
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
