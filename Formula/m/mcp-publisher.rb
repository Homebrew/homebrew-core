class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.21.tar.gz"
  sha256 "3bbc87977ed7731f89669590361b275c2e2de8b5f77babcdf2a443949b531461"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "cebd883c1ec1da145109114f9f8b97f179fbe2a69d7e63dfcd44752ee4a91901"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cb0378a209389a5a3dcea37df5ad3778e69fee361647fef362bf37f471e9396"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cb0378a209389a5a3dcea37df5ad3778e69fee361647fef362bf37f471e9396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cb0378a209389a5a3dcea37df5ad3778e69fee361647fef362bf37f471e9396"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe9c3afba2c69acbd99e9d65d3f16f7575c26c0c1dbf4e219a3f7b673a51c598"
    sha256 cellar: :any,                 x86_64_linux:      "5e81b5ec90b2b7720482f5836947371faf5a8b86fff0d0732edbbd586c5c2746"
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
