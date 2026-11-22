class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.13.tar.gz"
  sha256 "f077a25652976bdb57038481a0a0a86189de82b586e5e8a0898afe482a3cafd2"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "b84e2dbdec6e7e6a58de0f7605f99085bcf49a1d52b12bacaffeb214d773cdd9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c41aead01c9ffa0408467f51f9c7a6ea07a419aa721ae6c3b7c0aa7e2761c8b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c41aead01c9ffa0408467f51f9c7a6ea07a419aa721ae6c3b7c0aa7e2761c8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c41aead01c9ffa0408467f51f9c7a6ea07a419aa721ae6c3b7c0aa7e2761c8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13bbcd1f055fb5bf802cef6c2eb577112202fb40e007a2f78503b5872c471064"
    sha256 cellar: :any,                 x86_64_linux:      "40c7b00c049769b0552158a17589dcec65738564186c15220db85920ca6dbfb9"
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
