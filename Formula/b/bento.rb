class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "554ef3be2d39de952ef18c0d8299f02a2a6a17ad3950a6f1293e4eb80e43d299"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    port = free_port
    (testpath/"config.yaml").write <<~YAML
      http:
        address: 0.0.0.0:#{port}
        debug_endpoints: false

      input:
        stdin: {}

      pipeline:
        processors:
          - mapping: root = content().uppercase()
    YAML

    pid = fork do
      exec bin/"bento", "-c", testpath/"config.yaml"
    end

    begin
      sleep 3
      output = shell_output("curl -s http://localhost:#{port}/ping")
      assert_match "pong", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
