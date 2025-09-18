class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "71c4810ed2171d4ed7bbb5519826a141f6eafd1b141bbe3694e5924a88bd7fb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6ea523ab9852ddd43cdf2a7d22cd0d8ed040dc52f5ffe37fa465917af92ca6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ea523ab9852ddd43cdf2a7d22cd0d8ed040dc52f5ffe37fa465917af92ca6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6ea523ab9852ddd43cdf2a7d22cd0d8ed040dc52f5ffe37fa465917af92ca6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6ea523ab9852ddd43cdf2a7d22cd0d8ed040dc52f5ffe37fa465917af92ca6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0cf893d782197b74d69f904b7b3ad8a2cc1e5221997789579e567960fd8c7d9"
    sha256 cellar: :any_skip_relocation, ventura:       "f0cf893d782197b74d69f904b7b3ad8a2cc1e5221997789579e567960fd8c7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdabc47cc57e13c1009984553f898a69fd651ebedbc18f181202ec0d7823760c"
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
