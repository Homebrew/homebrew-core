class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "538a77ecba470fad44835b60672642831fff1fc116fcf450649c619ed82d9e8c"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2b281a4543a159bdbdf9e00163ff378af007befdf365fb3f253434a59dbb78c5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd39178a3b02d80b43e68fd5f49ca43a7c0127d061a79fe236627ad4f0496473"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8b167728fc1a58ffc23c0757ebe00322f00d969b1f78e16269d530308473f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97b0b915fb98595d94d5f40255203418e3f1de1390e89e98b2e7bec6fd559a2a"
    sha256 cellar: :any,                 arm64_linux:       "364a8d1d84af2289450b46a271f3cda59c71cff2b7bbe0083b34dcfc9f672d57"
    sha256 cellar: :any,                 x86_64_linux:      "36df5fbc9d87976d1dc5d737ab361dc1d668d836481daf01245a5d718d41710f"
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
    with_test_process(bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s) do
      sleep 5
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    end
  end
end
