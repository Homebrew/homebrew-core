class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "ccb0b0b2af10a3b15e23ec68e65583a876cb631f93635cfe7d458382d98fdcbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c30960e0b38cbf9aab1ae9417c7b1994b3e787b38e9ae6059ea20586a3a61b62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce8e3ab4d78e77055c2f08c740812e62b9c9e72e41c8b4173b7b79cb28acaf24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dab49ad7fe090148fa9bb5e51309693abd43f18bb963c9e4af11f2c21d1480b"
    sha256 cellar: :any,                 arm64_linux:       "b984a0ee82b8dafdb4f56e00c3038244fdd81754dc8ced29a795fd20dca5d7c9"
    sha256 cellar: :any,                 x86_64_linux:      "95e39bc6706d1312418716aa171cdae07d064fbd753e2ab7265ca6661e8d0fba"
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
