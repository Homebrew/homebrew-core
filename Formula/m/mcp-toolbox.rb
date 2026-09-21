class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "c3665c21ac7671e9fe8582f8fda956e41daa46991f7f1fba1c717a39534e1f1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ced40cebe0d7f7dff6b73f22622d726287bf2f35a029f78c868ac7f4cf55c27e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a075e2de1007d6e528c629ad842821049644227da2ff828436cd256ddf67e5c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "635f4a4a667bc50e286d3c883e8e17e25419463f6bc7160a28ddc5c8e9393cde"
    sha256 cellar: :any,                 arm64_linux:       "99e819787f9673422f121df3ad7bacb489da71f285cf17fa8a887dcf40686bcb"
    sha256 cellar: :any,                 x86_64_linux:      "2536a9376f53b8d1af9763a05cc938c5afffe9e66fbbfc97aae3ba3a6b990dd3"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  # `test do` block binds a local port
  allow_network_access! :test

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
