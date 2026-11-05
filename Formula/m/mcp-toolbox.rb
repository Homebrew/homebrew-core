class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "17090c37ff486feb8bc860f40792147891976301d576cf4ecc9b0df889019e88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9be68c6924b7a3eb21a27235e19f34466aaa7a004d27f2f1a9f6d5499bfe506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a7cdfd8f4fc38f069bc3a3043fb3fd74efc719909c2004e8d6013af28ab72e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f26e28bbc4d19d645ab688e521d30a217ee2a4a7053624acce7fc222850ce3b2"
    sha256 cellar: :any,                 arm64_linux:       "492114e952b1c1c2fc8100b4a925a09f17810bc4f56d1fe71a27cf21fea89d16"
    sha256 cellar: :any,                 x86_64_linux:      "eb6f29ad23a7fcd7b3da491f3623fb6e3dbe9e2f58248c7957ca8f50608bc0c2"
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
