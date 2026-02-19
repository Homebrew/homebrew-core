class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "3d92b9a6514182ad3a58a855767b52c00fdd07816c92c76d555cc64c7a58d4ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac65c7bbdd802fd25bd21ab7a693ba85f50c522f04cbc32d84c6c9981e82736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9fed1c0c94c5e3e1aee35fbb99bc2f00af59694ed2f6a2ef9ccfbb1e8400ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f8b95b4c3cbdd7dbbe617076df11f3ed33de740bd53bc030d140bd63bb74de"
    sha256 cellar: :any_skip_relocation, sonoma:        "230a1f7356863f1aa9e7ce83928160c8b1be7b11fd340d61366ea0648d56262c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76ed7dd161e03db2474f4189f805e78d1234485bae0e63687abfcdd5112fb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0d4311d501b8fdd3d727a38e187b5272bb8d9c1935741a087757f1793b495e"
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
