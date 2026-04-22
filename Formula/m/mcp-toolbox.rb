class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d94c836f1f12495d022c461f3b4e1258865b944587a8145c63a5f8b9e6c7caa7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c1841c6ecf4db5d4ef984961c3166534ae12e6d81d3217d38233e855fab7684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e35baa67aef71509642fb0e9dcade22d0ae3fae9caa921728e13398818a2afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d89f57dab5baf5b7f6b733483868795c0d565028bb9b66e49f300c500c1646a"
    sha256 cellar: :any_skip_relocation, sonoma:        "007c47e5e241a78e1c22d76f025ad1502f674eb0a9352ffbdee5831d001917e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd7fb80800e037fca8bc363fdde55cf1f425072832174355faf620cc77b3a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be00aba1d8894252f60b2433a19fffa27ad855f098a7587820bdfdf36b5fd2b"
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
