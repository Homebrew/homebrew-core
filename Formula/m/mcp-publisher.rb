class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3e1fbd86be0dfedbdd9191fb89f0fc7fdbe5814085d18cb95244eb1efe0729ef"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b05516c9e196a05fd3185f76bc83232854066fbad70d8bf8365abbb281f93b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b05516c9e196a05fd3185f76bc83232854066fbad70d8bf8365abbb281f93b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b05516c9e196a05fd3185f76bc83232854066fbad70d8bf8365abbb281f93b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef68dcaeeee79832805d51d1810f70a3c2034e171c622b6a960375bde8f6d9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da48204bcd8c3563fcdb37ae9a538e6885c93758b053fd805e780459324c45ed"
    sha256 cellar: :any,                 x86_64_linux:  "78cf801fa11ac407b01f827282b9e8b5b8fffffc0c37708eea02a5cf841f6693"
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
