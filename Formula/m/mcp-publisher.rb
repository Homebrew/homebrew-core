class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4c8c22e4a47dcbe8b75904b4a62efa62f20b5e92de8cab408b2179ae19abc120"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba32e606e019a19dd1951e46ece9c8f1d1322a98be5c81e3a05fdca487ab96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba32e606e019a19dd1951e46ece9c8f1d1322a98be5c81e3a05fdca487ab96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba32e606e019a19dd1951e46ece9c8f1d1322a98be5c81e3a05fdca487ab96f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bba32e606e019a19dd1951e46ece9c8f1d1322a98be5c81e3a05fdca487ab96f"
    sha256 cellar: :any_skip_relocation, sonoma:        "45539fa7500424a1e0ff37dfa88505d902db09b452dae7aded5f6566aacbf9ef"
    sha256 cellar: :any_skip_relocation, ventura:       "45539fa7500424a1e0ff37dfa88505d902db09b452dae7aded5f6566aacbf9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2591a1d992fc0fba23a8dc49596def0948a71a14a76ef0b72f1e86023afad0aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
