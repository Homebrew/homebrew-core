class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "667a0d78c9c3c319ccee503951237883f1402dda33cf27f2e64af2faaa54412e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb49d58ab8929c00c1358ba9ac9f51e4534fdffd4a7bb19e48e8db3252b827f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb49d58ab8929c00c1358ba9ac9f51e4534fdffd4a7bb19e48e8db3252b827f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb49d58ab8929c00c1358ba9ac9f51e4534fdffd4a7bb19e48e8db3252b827f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6800a1e6a4f9cca0921493e0df9f1c2090b7a7e1892824acfebe255dce203883"
    sha256 cellar: :any_skip_relocation, ventura:       "6800a1e6a4f9cca0921493e0df9f1c2090b7a7e1892824acfebe255dce203883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efe5ab3e11b093a16037a06b05038d1eaab6e7b845b266e1657c83a806c4826"
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
