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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84495337a577ad1253631d4d3f41d782b4fe6b5071aa10bc56221a27d527f13c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c056a1caa0b53ab37f7872c187c71b8c0bb8957411faa3883b6f5529388d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7864ee30b322daee8377f7095938cb59e296438cda606500b0bf537167d30024"
    sha256 cellar: :any_skip_relocation, ventura:        "77e5a6d390e0072268e6700daae15c56019ee5c08ddff975ae87d9eda7333c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "422ef37276691514ef1654d724a55c4271c0a23b9e6badd98cf3c1f5c4d88765"
    sha256 cellar: :any_skip_relocation, big_sur:        "8111b2abb9fcd50888964dea6aea756623b454955549f9854dbbf1cdda817544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8e3e074705f761c303cf9ae7d306a17d5fb142f8268d8d0dcee52ec5259de3"
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
