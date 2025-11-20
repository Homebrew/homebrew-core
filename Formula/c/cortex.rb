class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "dc59a65017b0caaa46253a300abe23269ec42b2de85ce7501cc82ad9e573f135"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb5a2ed852611cc9d2879c8f633c2517da45d9cc064f41c633dc4f57728f8a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47800e84f38f085d49046343808436d8ff6d9d959d1d80d96276d18c2bedae1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3358f810a3559d45d9ec0f37265e734fc10eba2828e9c25c77f844163633ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d17c5b852ed4c8f7424e987a57d263ce91def5438b9ef8ac26589b3ab3e15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ce171299eb833266f359d6eeba46540cf10ec7657b62d04bcee73d7e5b510a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77967653712919a3a04815f05cd814ca58448d20ea5170865ef4c2b88a2f0099"
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
