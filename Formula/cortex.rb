class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.14.1.tar.gz"
  sha256 "cfa37a1e8a30a49c8aba4da1cf2f9a60f64dc6a46e74375bbc3d0e9961206cc5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c7f64f8d7a348b28391239033575dfd5d445a9bdbddfdfd87443256573bfcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdc38e118f8dc20d83ef5d45173f2deb1a71417cd9c5b65eabbd311156ae09a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44833a8cea9fbe4b5626eb3b766ac09801a7cb8e047d745855dcf4c84bc76ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "e210ad047e842da0f871b025ec61c1ccb75dc4ccd8d6a362ce9de651cd19b5aa"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0553dd2c0b48395df3662fee739f3b59fa2548179c1ab8c9ef45ede54c3d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9553f34a954002567b80d9bc815a1734755fa2c9a91df4cebd98a6c742e62f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f80837c01d08f1bd0169119583641ee94be4fc646c7fe8f1f4b7b8ee6e8f4e4"
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
