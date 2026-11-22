class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.13.tar.gz"
  sha256 "f077a25652976bdb57038481a0a0a86189de82b586e5e8a0898afe482a3cafd2"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "e79e0acec53d33fa7b4d711de239d9d2097a988e0d9b1981181e6d5d7384e305"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d00a494d1e43471b9d4490e7c2215bb54af598eef7561644dcc6a6427208507b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d00a494d1e43471b9d4490e7c2215bb54af598eef7561644dcc6a6427208507b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d00a494d1e43471b9d4490e7c2215bb54af598eef7561644dcc6a6427208507b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f94532b80859d96b3f54501b41be3f19072f96cc7bca36b20731b93c2a952ed"
    sha256 cellar: :any,                 x86_64_linux:      "67ea77a7581772ce8878236b4345d3307ccbeffe82db1b955e1210a5f54420f0"
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
