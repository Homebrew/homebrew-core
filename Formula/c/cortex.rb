class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "9377a555164535c8da27c86a7f29cd877e3825f00891c6d4957353d8cca8498f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8732ff29d9cece1f7940bc8d1b0ce7f0fadabb979690a94a0c7fc30aa0c973c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049b3895bd90b1c59d88574b2f7dc47886160adb3ba25faf234ebc1b2b7a6ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123b9e1754dcaf1915f036999412e9481fd74b6aed4ed6f7f1f7cbad13fc9001"
    sha256 cellar: :any_skip_relocation, sonoma:         "59eff1291e39332fd0e6dc85f72f47dc6075561cf215d1715f543a43a722afe3"
    sha256 cellar: :any_skip_relocation, ventura:        "ab5ad793b65ac32a6babf58b1e0eaea1c69382f7b18a67a273df797aebaabbee"
    sha256 cellar: :any_skip_relocation, monterey:       "5323d741bbd7694e674ec38683e7d8eb61405e3542a181e9dfc7dd235ec7054c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95045a46dc5fe7c4340cc74c83ab121743342e39efda685399bd8da2fb98f59"
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
