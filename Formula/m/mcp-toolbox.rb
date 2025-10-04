class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "996b1d8197767acd58bf507527373157e57b2758105b59a1835051194bda1733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a7229c9d491b06c4a280a0e04b08e13f3430f430ca38217c7dd10b94ccea66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a7229c9d491b06c4a280a0e04b08e13f3430f430ca38217c7dd10b94ccea66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a7229c9d491b06c4a280a0e04b08e13f3430f430ca38217c7dd10b94ccea66"
    sha256 cellar: :any_skip_relocation, sonoma:        "713e7aa95115a08df0376d884e3940a37772e44242a9022b7f47adae76a8700e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40299780673ad150c5b869e1d6a140d66711129a513bc5dd442f7dad5ffa897a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d439139401f9c5d2b7f37cb4bf5f95819a2dfa528cef9354b90f8078089e207a"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~EOS
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    EOS

    port = free_port
    pid = fork { exec bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s }

    sleep 5

    begin
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
