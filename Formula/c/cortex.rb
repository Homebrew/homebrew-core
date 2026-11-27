class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "eebef940dd30baceffc2658da4a5ef85911246dd2abd53e257067131cb97e853"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "f6247133a212a460ef4bd88dbb75877ad8ea607383c9f250398aacdb3b073757"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32a087ddbca6e0c5b73f4b20f93a578449dbc7ee8f4220eb13a3f0dfea707626"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22f5b203a7b4a4bf86e956d8540b2907d87b04651fc9ea9391ee9990efd62f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0703caa7d4badfe64627df32a8ace39d1c98db4d2f61de83c322a2222575240f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64d17ed5843440b22655b3b1bb20ea39dfa5b739c7760b640eb2d55c4c8242dc"
    sha256 cellar: :any,                 x86_64_linux:      "30e3b20395cc59c86e8fc615084cda8f061dd7cef315d641b6d3428fbaed5c96"
  end

  depends_on "go" => :build

  conflicts_with "cortexso", because: "both install `cortex` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cortex"
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
