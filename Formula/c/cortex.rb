class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "606c4b3b2c25b2e339a53bb4d103dc31417742acbf078c4bb2333f66c331f09e"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e86a0a76dd5d0c010675f07735b3cbbf94f487a5332764915f54697eb4db89b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da6e0316585d857d5325c9ad80d64b8a7cc19b715e517b64f2aa6184bc0a8e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5256ca98ca78dc9c65feb1cee165a67067ffca426c8b91545d35cf962aec2dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cecedb96cd0e90c2c5214da360068360140864f71773b0c077e8756ec8b0e128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649fa031a84da07ea86a2b8d8a26d685b92dc2dc65126d694abd27bcbcf7d9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208cf7780d98e6531262b1242560688cffaa2a43aef6d1cd98f792a41dc17974"
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
