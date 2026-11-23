class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.16.tar.gz"
  sha256 "745fb7ed8b0a654dde0984995116c2bd7aeaecb1ee3595e9137ac336f58ecb53"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "831db56b90bd573840870d01529b6576b52b126aa3acbbf5a04dc73ff27a770b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74e5db78432b4c0426c20e4438d26aac67b866c8f5e0f9b9993d687f4f98669c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74e5db78432b4c0426c20e4438d26aac67b866c8f5e0f9b9993d687f4f98669c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74e5db78432b4c0426c20e4438d26aac67b866c8f5e0f9b9993d687f4f98669c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "203ee11c69d466c6b32753044b69a8107b0d8a291e1d99dda89e216e308c7da2"
    sha256 cellar: :any,                 x86_64_linux:      "16e8c5228796199a12403f5dec0355071fde0e4b4c652d4f85f907018e3cf488"
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
