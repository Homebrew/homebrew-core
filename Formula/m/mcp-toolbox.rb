class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b60cde997bc881ff078324c970444dcbbd0d1321c0c59a0dd6d3160ea52a2555"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "668bde02e27eaff91eec851e3348eca908fd8cae092986797d4fb9066121c80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f34087d11824d2eb4c4d2bc14630d804b75750558a5090e172413b0a4767c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e268e1fc15c7315905b83ea80be34a33326377f1cfd971d85da9666ef8b7dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c2b57ddf3e3a8adbdd13f49ec8c6329edb70d20dd10ebd8cc34d3f85e8bd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96efc7358f353997588b33618133f445508e669525ca9bd6ec73802aee5198c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf933f55b6761ef2d4a65a06cd2672ba81b567c65ceab1891b88b1b755974e6"
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
