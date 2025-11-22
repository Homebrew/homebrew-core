class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b96d34c94c3ddfb881cf80edc51ca39387c03091ae5668cc8d27467f9d295957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d207a36a40bda5cf2b08dc023020cc1f8bfe17f9d17c72d7ad72348e8cb72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d207a36a40bda5cf2b08dc023020cc1f8bfe17f9d17c72d7ad72348e8cb72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d207a36a40bda5cf2b08dc023020cc1f8bfe17f9d17c72d7ad72348e8cb72c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1345f370712620f655625d2171705b6128addee8912e429815c69950d7b4899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ce93e34ccd3052a940d045ad7887e12df0537cf80edf9ebfb59c978b351cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76b89bc3028ba02180503062ff2682cc8f17c3629f48bd8ec31991b8d3c0f8a"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
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
