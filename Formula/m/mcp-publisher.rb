class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.17.tar.gz"
  sha256 "2974b6bc5cf7310962c1d7bfde31b34e360372b5153daa5a21d63f98ac20ef8b"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "93e8c3b901a5b0ea6d5e56ca4cc136c58a390efa8b5e83cedd6601b6ca01d561"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60c2c63878ced07a851b8068b19212e69340261add1b3747212cfc544b3303f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60c2c63878ced07a851b8068b19212e69340261add1b3747212cfc544b3303f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60c2c63878ced07a851b8068b19212e69340261add1b3747212cfc544b3303f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c89ecb30a6bc9022693baea8d88506390ae12a83607d1f8d67202dc1fc66439f"
    sha256 cellar: :any,                 x86_64_linux:      "baf80544b95b953e8b474750e6de3b588d34686548f27bd2b6c5c0c03d205ba9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
