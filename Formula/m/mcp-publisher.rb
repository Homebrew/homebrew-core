class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "49000e1f91462b49a6a1421db97749834ac5eb1bfac7526d6d932684d5343315"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "413d527c902eaec5d85e4e042af1160572078af20154a9e3af2fdf66d8f2499c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "413d527c902eaec5d85e4e042af1160572078af20154a9e3af2fdf66d8f2499c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "413d527c902eaec5d85e4e042af1160572078af20154a9e3af2fdf66d8f2499c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "310173d46f5b8b7e7ac411683f55e8e9955e4cfb853369e821c02174d6c78647"
    sha256 cellar: :any,                 x86_64_linux:      "7ed59d79ee2b6b1a99959cbaf2f216093e58ba6e8c2ce9b976aa5c0601129b35"
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
