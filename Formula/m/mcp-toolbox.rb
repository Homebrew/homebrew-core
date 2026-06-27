class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "af70745e34a51f188659c629d918f0cd51c21cc563676a72eae878776d20e166"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6dfb4296a024b935e50f00e205583d048921726ff4d413a46f5965c0e2ffcdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686710676e45afc4bb1770ae0ac4b838c5ac7ee9604f2f54654c789569671aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56ebecba7bd78482a29442090c0632fd3ffc3708654654dc26d90580e952774"
    sha256 cellar: :any_skip_relocation, sonoma:        "11d70d250b38c15535aa047e64911e3e2aa9eb734a875afaa1837034d9dd5cdc"
    sha256 cellar: :any,                 arm64_linux:   "1fe4897ffa8c65f5c43f7269f822480a4553aa7c57b9b099799970a9a0d27776"
    sha256 cellar: :any,                 x86_64_linux:  "2d5e330c9c04ad6512bf7f87cf239c36bd779eb8239f934832d2e1a580a4ee77"
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
