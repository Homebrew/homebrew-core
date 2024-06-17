class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "2bfd9eeaa96a1c3c7a5100d99f0095157e55f3ac2a145c0d2cd1d23c994441c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f76299f611075a423b8416bbf22658ca5e4f0d9ace2ba28178ca81df74a0289d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964f222e4d06e6bb817a26213a306d3b600f41ed799df0165d896f079a3ad3b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b30410c619d049f731d2c9eba115b3e3c9465768da37eb5689a4bb12cbb761"
    sha256 cellar: :any_skip_relocation, sonoma:         "9869553ffbc4b7a996b37c52ab6139c7488e4fe9bffea3a3f48cd0b862217252"
    sha256 cellar: :any_skip_relocation, ventura:        "3aab8ac7fd807da1568fde979361ea605a138bd4ee0ee588506f2762993aa212"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e5d3b16a11e0eb04bbcccb0f942504147deb017f2dec1ca9758a1af5dece19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99864ad36ccb938578f8ebfcf0023008f7c436d5865e9b99ca69c18383b79334"
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
