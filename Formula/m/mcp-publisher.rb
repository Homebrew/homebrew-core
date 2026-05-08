class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "5cba1bb77a114bb8e8a215c54f22c87fe73cca34c41b70bbd1c9d73f5048dfdb"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da8983ea41b509c65cc85131a8794be1477d49775a08ce554dfa7fbfaf57ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da8983ea41b509c65cc85131a8794be1477d49775a08ce554dfa7fbfaf57ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da8983ea41b509c65cc85131a8794be1477d49775a08ce554dfa7fbfaf57ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3aec71952a2c47720e27156ccec95123f3f4f900e395a2b2aa86f4088528930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "237455d7f20c7df050a65c56ce67ab021a9024d16325723c37822fb59fab9007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c3ca0da0a35c1bdc5e186771f413de7f46eb188f8fd0a794653e9c6f89f1ef"
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
