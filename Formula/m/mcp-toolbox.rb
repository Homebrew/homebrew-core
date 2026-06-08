class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "32bf3adc8f5d3535531221a6b74284fb30c3214c6b62d0d7003e239808db6787"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052d22df7ad9f25cccb284bd92e0c6d0505403894f357da4daf1c6c579ce231a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65060db26bd676395861cfdbe01740729362801164d0c9ac665f3e886515e289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38109eee3f649748dec5bf5d1d0a7ace10c2d6dfe1c57b0f568bb99e382667f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b474521821c8babcfe973193c1d1009030574242b7023ea6a5d7e741a0bd6f6"
    sha256 cellar: :any,                 arm64_linux:   "45d9a1aadee007e7f44f638c6662484d441a3ff83f021683df8506369eff62dd"
    sha256 cellar: :any,                 x86_64_linux:  "8567c383ffe6c434b486670439ee7dfa23809164d08e1e6f38e149ecc7aa3977"
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
