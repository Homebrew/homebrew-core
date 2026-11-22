class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.12.tar.gz"
  sha256 "de23ef8c760c671298797537c7ed74465618a220f730afa0d7ec08da777c6904"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "e985b6ed28c648cc617b186ce895fa414873fd481c8fd02060ffeada6dad10ea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7fea79d29b55e16ed21c22bb2d2eefeb09db6c2e2d2314be2bc2628fab4dcfc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7fea79d29b55e16ed21c22bb2d2eefeb09db6c2e2d2314be2bc2628fab4dcfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7fea79d29b55e16ed21c22bb2d2eefeb09db6c2e2d2314be2bc2628fab4dcfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10c62873d0f5beaa86080971e11fc4f8ce9c70968a42561e109f9257d9a17504"
    sha256 cellar: :any,                 x86_64_linux:      "0777bd6fb965cb677f2b28b811169bcea7297b6d3c48e652241b5c2d272ab8ff"
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
