class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "7cb6b312f67263e40fef3a99afb7d12bce69fe035e7b787b9c1efb4bf7a693bc"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcda7547e90bde4e7466eed576f853d1b024fa730f6a2083f35db2ece003a0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddcda7547e90bde4e7466eed576f853d1b024fa730f6a2083f35db2ece003a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddcda7547e90bde4e7466eed576f853d1b024fa730f6a2083f35db2ece003a0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2f54b88703909eb151d7d7af35b576a36bb1d6f58c1401f7b1e884e14ca123"
    sha256 cellar: :any_skip_relocation, ventura:       "6b2f54b88703909eb151d7d7af35b576a36bb1d6f58c1401f7b1e884e14ca123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5fd77ae5c2bc6afe90da427f3a780adb07896bb655c09c57b92e5b0423de2c"
  end

  depends_on "go" => :build

  conflicts_with "cortexso", because: "both install `cortex` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cortex"
    inreplace "docs/configuration/single-process-config-blocks.yaml", "/tmp", var
    etc.install "docs/configuration/single-process-config-blocks.yaml" => "cortex.yaml"
  end

  service do
    run [opt_bin/"cortex", "-config.file=#{etc}/cortex.yaml"]
    keep_alive true
    error_log_path var/"log/cortex.log"
    log_path var/"log/cortex.log"
    working_dir var
  end

  test do
    require "open3"
    require "timeout"

    port = free_port

    # A minimal working config modified from
    # https://github.com/cortexproject/cortex/blob/master/docs/configuration/single-process-config-blocks.yaml
    (testpath/"data/alerts").mkpath
    (testpath/"cortex.yaml").write <<~YAML
      server:
        http_listen_port: #{port}
      ingester:
        lifecycler:
          ring:
            kvstore:
              store: inmemory
            replication_factor: 1
      blocks_storage:
        backend: filesystem
        filesystem:
          dir: #{testpath}/data/tsdb

      alertmanager:
        external_url: http://localhost/alertmanager

      alertmanager_storage:
        backend: local
        local:
          # Make sure file exist
          path:  #{testpath}/data/alerts
    YAML

    Open3.popen3(
      bin/"cortex", "-config.file=cortex.yaml",
                    "-server.grpc-listen-port=#{free_port}"
    ) do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "level=error", line
          # It is important to wait for this line. Finishing the test too early
          # may shadow errors that only occur when modules are fully loaded.
          break if line.include? "Cortex started"
        end
        output = shell_output("curl -s http://localhost:#{port}/services")
        assert_match "Running", output
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end
  end
end
