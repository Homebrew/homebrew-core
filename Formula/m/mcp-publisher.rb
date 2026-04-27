class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "29a638f890b71a73d55c73096cf7abf037ea9b75f69df83c553e6722d1c3a06c"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6fd56eb90af09dae043cd5e88ab67f915648a17e2d0b9894f2983445996a6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f6fd56eb90af09dae043cd5e88ab67f915648a17e2d0b9894f2983445996a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f6fd56eb90af09dae043cd5e88ab67f915648a17e2d0b9894f2983445996a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f7b6cdad576077274ce83169c1c96a8c91074e83ba97bf0d08a575fab74e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17ea00746294412e29562905f33335cf046463b24107fbd285863f8cd9dd6f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56ffa82e6873c3744cf82f68c2d0f1efa36c980f21719244db88f7c489800e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
