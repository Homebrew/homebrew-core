class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.14.0.tar.gz"
  sha256 "cb858658144679145ae8433f3c732ff7363e4ac1819c6fca373e2b9dd81f297a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8945b4b91777966b7843829e9da158cee4d49e1e4ecaf584bafa414301ffc605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e575c8db34f377faa212eec5f0ec7d478b3daf4cf10bd2698a9a1f1faec8332b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "344f842dddbf81a1169f8b53ab9e550101e088177b328472642a583528e9b166"
    sha256 cellar: :any_skip_relocation, ventura:        "0bb36b519501f04bcd337376dcfb644f7ded2e94a1b597a590bd96690a1925a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f9dcf2a61dbe5bb8312b7853834ab1524b15fac15f7f968c9c690aa93ba9bada"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5ac2445ad9eea5364c0ec13d306965ccf7bf3156e71deaf5fd1eb87a8837982"
    sha256 cellar: :any_skip_relocation, catalina:       "5169ce5a37d08f88fcd7defe6549f83a0cf3da9a3fa84535e6d4e8427abbb5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c6fd5209e864083236ece46e0603f764ac910a47183e08d12e747b89be6f9e"
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
