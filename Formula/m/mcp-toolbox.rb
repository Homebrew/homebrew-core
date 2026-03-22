class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "86404bc3ba05c582eef79f5ba55cabd4e752fd50be6c954e0119ccd2ae1c71d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85d1e3fb4ad19a9cc5636969ed49ae86679426aa595ba910faef13b4712380c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "082c0e3c31956179fa0df3de98a11846c4633db126832a113279996f76491c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb3846278847d3715625ce802b75ac2b23c787237c4a14f082a782a6953e966"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb752eb570238164d964e03c9ed92e1f6c5f40ab434581c4f540a591025ab76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33399b55d01573620c301250d5ce1ab153927da14c2b66d8e044c1e5e9fffb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6846f33ce9b3554f4243d33763b9cadd76f77f6c9e5071b5148c55d46e99b9d6"
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
