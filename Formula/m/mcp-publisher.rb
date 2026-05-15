class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "1347619339d3e6ecbbe4d17a4503bc331da17122a00a3d804eaf26898f40ea47"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37792e8554ad120a2c1ee3db5a4854042af66ced363ccd506a3dedc44c7189f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37792e8554ad120a2c1ee3db5a4854042af66ced363ccd506a3dedc44c7189f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37792e8554ad120a2c1ee3db5a4854042af66ced363ccd506a3dedc44c7189f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4de96faa7eba89f45ba13373f578823c7b11159083a861f91302bb8b90afaed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "618d321d7403a818d65d006a4efe27da8c038b73fe699de151e3bd1b7344a4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b262e2e7bff8a0400d3df2e3878e65d93e10c52cf36574ef04a604ceed431c58"
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
