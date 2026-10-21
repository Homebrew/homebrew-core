class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "3dc8b7578b0549af3c7fb437cadb616d7fe9d56906692818edaac133fe6125ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de93f318a91478471c773f43ca81d5841a466dad4dc6a321de3496bd31657d16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "817209cc82ac91884e47608d66dd7aaa8c6674fe29c08b380907b66c411a5e7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d05ce5a9f6c917e97a32dd4660a698267360ff17161bab4ba178ae601852684"
    sha256 cellar: :any,                 arm64_linux:       "670b3e33e701006c3e4570f9a7ab22c9a68d1ac0953e33e76fc2a0b356b735dc"
    sha256 cellar: :any,                 x86_64_linux:      "c450274ea478cd01ea252ebb60c9da4171025cb6afeafee451010944e151d8d8"
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
