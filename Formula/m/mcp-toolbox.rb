class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a581c45d424d0da1ec6dfd3162509337084d214c10c33bfe9b389be7e627c75e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc656310445f2604aea3e6b1f48e7f9a793dee03c221b387516ea8257390b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc92df5dd0afa80b3c1312db72e1e6a4157658ae1389b30798a62ca0e5d2325c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35218ba4722933ef27b368419f772bdc01bb7b763a57d44b47b7550877586d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fbba30f597caeaf120e1564e1252928b627daa5677fe34307ae80eebc41123"
    sha256 cellar: :any,                 arm64_linux:   "2b121422ebe10fabab9ef8da272142455f77eedaf9c7a857915c37972d7538bc"
    sha256 cellar: :any,                 x86_64_linux:  "87a3287e6ff1d1028a328a916c3892da65bfc1f2b24979c7d525df79575585d6"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

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
