class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "95c7ef093158e001c9e95c20acd4aacf75c119d727e28aa014ac63ad6b02afa7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca84209f747f2148e21224210accdb089fd110c98159f3f96107e96fe839e81c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c4287601d40b199e88acb0c146c280bb67ff0651903bbcaa75bdcfa6c24f617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c249e9492b55e649210c87ddc85f2a9b0ab45bcdaa182c515c6c98eeb24997e"
    sha256 cellar: :any,                 arm64_linux:       "40eb6bfbdef42c4feb27c6562f302f89c882c0fd76e9a11ed274531af50c0e41"
    sha256 cellar: :any,                 x86_64_linux:      "2f4397a883b9d3bd30a76d00ac3c62eef4007ebf8dd708a84c406df85c7ff22b"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  # `test do` block binds a local port
  deny_network_access! [:build, :postinstall]

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[-X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
    generate_completions_from_executable(bin/"toolbox", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~YAML
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    YAML

    port = free_port
    pid = spawn bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s

    begin
      sleep 5
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
