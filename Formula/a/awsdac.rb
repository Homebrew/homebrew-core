class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.24.tar.gz"
  sha256 "5744f58964e2c90cb8601c40060523b923205105f3456a7ac8ff0aa81070e7ce"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30675781e10c8206b49ded4cfb4f4c0141587fe19d6db302ef5c759996a0bd52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a632946d3a35ff29795bd7b34292b537a69793ca013d8dab6d5e9e3d50669854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a632946d3a35ff29795bd7b34292b537a69793ca013d8dab6d5e9e3d50669854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a632946d3a35ff29795bd7b34292b537a69793ca013d8dab6d5e9e3d50669854"
    sha256 cellar: :any_skip_relocation, sonoma:            "5d1f05cc95c768ffda7c0e6012baa5981d8e5cda82d9a3ca7f224dbb58ef055f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f542aa7e73224d8d95117208278efee0b84df39bc51dca725b0e0b55d353369"
    sha256 cellar: :any,                 x86_64_linux:      "6ce87c2e33290840ec5869a89ef6cd95138b50ea03ca96c30c736c1516d4dbe0"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/awsdac"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"awsdac-mcp-server"), "./cmd/awsdac-mcp-server"

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
