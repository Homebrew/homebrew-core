class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "c6ab6c41df7feeeb642184332fefc3527b314c3f0ce2d46e641995074a72d024"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95cbf2f34e645c2ea69445282f2c9303819bbf2dd38cbf6585d38f01682d32ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95cbf2f34e645c2ea69445282f2c9303819bbf2dd38cbf6585d38f01682d32ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95cbf2f34e645c2ea69445282f2c9303819bbf2dd38cbf6585d38f01682d32ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "47cf0dd0fab438b2594c617778f9f211c0c7761528226acb6c2f5f4206659fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ae638691a7fa06fb8051dee8ea5f2a6cca669453895db97dedf66ca7539e46"
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
