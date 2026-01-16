class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "7f7cf0123e19db010c43aea51bc8f46af495415fca530e01f10ea763b5713659"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b32f26f392e4bc727a5cb0042fc260bbf5bb051fe687957a9da2852e619dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c15040dc341ef27261520b2cd99843772697354a88a5e18d8558a367e70a65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b173f372ca9643de555e495b22a83067648da1f346a6cbacd6eed204515d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd7971f1160c4dc81c3835acbf2ec6c78316ddb32ce5bc5809d6461b8d18cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "642baa8ffc5363918cccd6fbe802e925a19c9cb0783c661ab20b821bb18f0b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5685b7d6c95ac5d7ec68da329d2bd77ab1a591bbd97b77d3acebc8eddaa056"
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
