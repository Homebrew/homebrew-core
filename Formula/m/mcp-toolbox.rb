class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "17090c37ff486feb8bc860f40792147891976301d576cf4ecc9b0df889019e88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85d42c61a5b7c041645642f444bd4f8d4fab9dc6fd1fe686ca87e20620d0e1f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93dc8bf01f574c55d63471bb632d503ed6e1a98cb317529e086ef2a955bb058f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af4d0cb201af876e746379875b674498d3f56ec97b685f066ec8840f4486c7c8"
    sha256 cellar: :any,                 arm64_linux:       "347d62fbdd2403847f9e14af3b21701bf9db6165cc7300b3b030e4fcb7f00487"
    sha256 cellar: :any,                 x86_64_linux:      "35f5f2f30d937ba9e3212be4bb2f80f9787bb932fa35c9f6015faed00161ac5d"
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
