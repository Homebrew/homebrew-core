class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.15.0.tar.gz"
  sha256 "096f688e110f3330d64a2909209d9938cdd8fa01f05d5ba945cbf6ec6cac3419"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e7c470c31ff5316a4f4835ee81e1fbaf26fe633eb7671a255f6c371142d1a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e7c470c31ff5316a4f4835ee81e1fbaf26fe633eb7671a255f6c371142d1a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e7c470c31ff5316a4f4835ee81e1fbaf26fe633eb7671a255f6c371142d1a13"
    sha256 cellar: :any_skip_relocation, ventura:        "273973bf8a5ab83e5900661071d68e190ac02fe2340a6e9669107adba37ef323"
    sha256 cellar: :any_skip_relocation, monterey:       "273973bf8a5ab83e5900661071d68e190ac02fe2340a6e9669107adba37ef323"
    sha256 cellar: :any_skip_relocation, big_sur:        "273973bf8a5ab83e5900661071d68e190ac02fe2340a6e9669107adba37ef323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf180fcf06cb092daf3d0f627fea0d18e4b012bb02bdce14f5dee2fcea176c4"
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
