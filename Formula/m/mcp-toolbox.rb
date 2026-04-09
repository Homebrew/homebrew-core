class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "c22fd305767d6272fc9ab9c1931f882b945f35cbe06f5380b6e50d5b6ec8e6a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249c0e932bc50808b14c5f99be26a9ba4704ad0a5385a7eb025a3271c37d78de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1154ceabd61eac599aa346a591c84b08d42d7f8ae83fd2f5b4dcacbe65e284d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db35eb0c39d27a33f229c8735994d21b19ad7a3641b23e0be3270bf3adb26ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27edf10f7a6d982f50eef5c093f597e1b272cc3448ac7b777ae14da5e84e67a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1250d803211aa6896d59bcf21b30a0599b350e240eb3a45ed3af0c8e4212b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20807b3e7dd2102009016f180d32fc182cb6655b53752e6974593987c590e9e"
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
