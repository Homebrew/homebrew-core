class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "713f398b52075e6389f09164e836dda4cb1068e7c2c4933ba488287fb084bcaa"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b67be067432524dcb8077ae3d6daee4d7dc3eaa8aede4144310a997b9f0bb093"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b67be067432524dcb8077ae3d6daee4d7dc3eaa8aede4144310a997b9f0bb093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b67be067432524dcb8077ae3d6daee4d7dc3eaa8aede4144310a997b9f0bb093"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45fb8659a368f7242277d366bb00689b7085dec9a9375a41dc21bc0bc411027f"
    sha256 cellar: :any,                 x86_64_linux:      "b650c23b0aef134d87f5dab7f542c05d5f9b61754cebb37132d13ff9a253a255"
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
