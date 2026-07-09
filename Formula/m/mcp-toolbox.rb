class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "846bdd7304a2fc18fe28dda729ccb1510ff86341b2cd4339a5a18cea4d527310"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eda18564a3337c34182613211b70158225cb7546ff3d3498d055d6cbd06f067f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52aedc132e1da2616a930dbbd2052c285d7057cf78ba1310dabbf447d6893cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde431a3741f47a43c577d7ae74ac19940f9f56b896a8afcff268c108e0846e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e385247591ae261ae2ac64ceb43cf80c0521be201ed9ac0dfc9d5955e2aeeb5a"
    sha256 cellar: :any,                 arm64_linux:   "f2846f1b4b40bbec1beff2b4f3d59b9384e07be76958c630d211e39d020aaabd"
    sha256 cellar: :any,                 x86_64_linux:  "480755df96289bb5127f1ecdd10d5ad3c20e1a910d0b96855b66a943aefdba8e"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}
    ]
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
