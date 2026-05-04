class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "eac862ef640e7f43adc25701ca457eccbc066fda444c3f7e742dff6dcfa3e604"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "826d6b59d1a33b21e2a2918486139aac3421762421ceabe455e60f2d69d46836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826d6b59d1a33b21e2a2918486139aac3421762421ceabe455e60f2d69d46836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "826d6b59d1a33b21e2a2918486139aac3421762421ceabe455e60f2d69d46836"
    sha256 cellar: :any_skip_relocation, sonoma:        "409804eb3018ab78ac18d5eca8ef1848142d91a0412c875ba123a26fed5ccf59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36a33a750716e524d2abeecb4e64006c6da1dfdee1fb195654a7a4a631d650f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6553f217cf0e1aad2c00c11e623f84d70b68ea7d58ee6a6226def80ff3af5f5"
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
