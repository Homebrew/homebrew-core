class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.18.tar.gz"
  sha256 "608e8b0009670aadde696b1e5f7233c7668b6e0d5283cefa1fac89a7c0ed72ee"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    manifest_sha256 "565038fb2c5dbddffd52f29fada12fd6f93567257fbc3f822298ce51efd6f7d4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6d23f75ffa6c2919c1d0d5d706b886fe4ddeb752791c3d83aa8bf1d5b3de002"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6d23f75ffa6c2919c1d0d5d706b886fe4ddeb752791c3d83aa8bf1d5b3de002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6d23f75ffa6c2919c1d0d5d706b886fe4ddeb752791c3d83aa8bf1d5b3de002"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a89d9900b8d63e1ac3a731333eb4a941b77d80e25ad11940cef181406e8890b"
    sha256 cellar: :any,                 x86_64_linux:      "ee8b51483701cd6c65d1b22a56b34e90df844282888cd9b58ddb2f7fb70b3522"
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
