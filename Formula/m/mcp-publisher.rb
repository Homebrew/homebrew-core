class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.16.tar.gz"
  sha256 "745fb7ed8b0a654dde0984995116c2bd7aeaecb1ee3595e9137ac336f58ecb53"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "1e92da141bf9a71ac2016897de83201bd5542d0f8fafa6c4a0933cce70d3ffeb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c3b61d9b36eb053205875337652779426ddb14ae58aa84be08600cff5a25e72"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c3b61d9b36eb053205875337652779426ddb14ae58aa84be08600cff5a25e72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c3b61d9b36eb053205875337652779426ddb14ae58aa84be08600cff5a25e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de89c47eef6bbdbd3b5976ff419ac1d96276330ded3f3b33378268e69b080967"
    sha256 cellar: :any,                 x86_64_linux:      "c14042e09d234345426e6ca549e074d976fae86e44f3448c4f35f0ba0d9df54a"
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
