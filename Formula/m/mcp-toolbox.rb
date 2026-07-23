class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "8b2998658faf2f038a9095f5b276cb6af2871090663ed53f7ed0625fec54509b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df15fb36f7e97a962c03355bf29802217bf70c32033996d281c45744b1fd018a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa2a5d8d90d0822236a17a0d4904a9bb888f81c53e069fb7dfda8281241cdff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00395c8d28a14e87f8788b3a2e4ccffd60bb3411c410df6131657c98566783a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c0cb12b987566b4f3639d70a5d2fb2a16bf363e5742772d7e22695028d0278"
    sha256 cellar: :any,                 arm64_linux:   "5c1fd71c345712e49ca55176f4801ae073e9a358d9ad393beb31a9b0dfc7e255"
    sha256 cellar: :any,                 x86_64_linux:  "57e1f9dc031e575bf4d7ee3046ff2cf321ccc0d0e1ab4557ec9c425254b6000a"
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
    generate_completions_from_executable(bin/"toolbox", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~YAML
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    YAML

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
