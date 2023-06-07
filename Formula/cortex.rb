class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.15.2.tar.gz"
  sha256 "1ad6c082614479365d6d89a817e198bbc078ac83229c2b757047265a7493225c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8642b1b9a22bfb0fb340320ecd4203d2bc66abd8a290778735b3ae8416ac1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8642b1b9a22bfb0fb340320ecd4203d2bc66abd8a290778735b3ae8416ac1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae8642b1b9a22bfb0fb340320ecd4203d2bc66abd8a290778735b3ae8416ac1f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0d85544d2d9b98bf1be7ba811f8d05706ba751d2e04af3e084689800e13ed79"
    sha256 cellar: :any_skip_relocation, monterey:       "c0d85544d2d9b98bf1be7ba811f8d05706ba751d2e04af3e084689800e13ed79"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0d85544d2d9b98bf1be7ba811f8d05706ba751d2e04af3e084689800e13ed79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aa1fa2e6898b17c9495f0c552cfe13fe912345a942664243ceae02123b322c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cortex"
    cd "docs/configuration" do
      inreplace "single-process-config-blocks.yaml", "/tmp", var
      etc.install "single-process-config-blocks.yaml" => "cortex.yaml"
    end
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
    (testpath/"cortex.yaml").write <<~EOS
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
    EOS

    Open3.popen3(
      bin/"cortex", "-config.file=cortex.yaml",
                    "-server.grpc-listen-port=#{free_port}"
    ) do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute line.start_with? "level=error"
          # It is important to wait for this line. Finishing the test too early
          # may shadow errors that only occur when modules are fully loaded.
          break if line.include? "Cortex started"
        end
        output = shell_output("curl -s http://localhost:#{port}/services")
        assert_match "Running", output
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end
  end
end
