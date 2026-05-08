class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "65af004b96115f25e292bc30d5ff60846e71d0bfa7a1174d9cfa1d6ca0bc536a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e435dc10aa0f144353c9015edff199de682e52498c6fbba33e5983e25c8216f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f0d581d48353e813d0efc17d2247f2d102c2c2a32cf123916ffa7bb2f388b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a5566fdc8d5aa6db5304801381516f08c4d18928b08081b70b322d0e64a24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9481b10cb2c00b8cf6c88dc9ce7c8b4a811e0708a35129d2f086dd1e8fe0dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69082bcef71341c90abbec1aa0626f3434f088772d9f7fee2bcddf6e4d3ff8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac6ded0a1c5c1817aa8eefc49e6db19e79fd5e3bbcefb02445975bc2b66abb5"
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
