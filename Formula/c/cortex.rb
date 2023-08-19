class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.15.3.tar.gz"
  sha256 "0a6d52faf64216ba1d49412d2ea09650d3228fed9b0c113c5abe738a25576239"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08cf26eef94fc949e40dbdeb5c028b4d27cb582ea5c047a61ed94f2457b95fec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08cf26eef94fc949e40dbdeb5c028b4d27cb582ea5c047a61ed94f2457b95fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08cf26eef94fc949e40dbdeb5c028b4d27cb582ea5c047a61ed94f2457b95fec"
    sha256 cellar: :any_skip_relocation, ventura:        "d4727b01516c8bcdef014cd0d68cac950399b87cf5c2b59bff975a8513e30f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "d4727b01516c8bcdef014cd0d68cac950399b87cf5c2b59bff975a8513e30f7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4727b01516c8bcdef014cd0d68cac950399b87cf5c2b59bff975a8513e30f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e819235ce5fc8ea63add27cd8d689bacb8a120e1ef71514b34bacc6a8f91d660"
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
