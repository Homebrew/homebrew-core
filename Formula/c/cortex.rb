class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "458486e076f9591701009ff0c36c4396c415b44e11832542e2cbc3ed30a27b79"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f7941e738968a9378e8e7cd7158f0718c8d78033841d6ef03e6b090bf88dde4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfff7ee0858a1dbeaa945370c8fd13e8bab2458387fad66940be54d7eca6755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec7bf7d78d7683ed79fcb52b4199149efe35742bc5a74240f6eb3ec69aedd66"
    sha256 cellar: :any_skip_relocation, sonoma:        "02508122196e19ecc981490c3ffa67daadd685ad74b08d662b1fa4056ce5d624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01be653d2f095c7a1b7409711305f4b9675994bb744a05fbf467a5da50971663"
    sha256 cellar: :any,                 x86_64_linux:  "45bc7e33471c7abdd8cf89494785ccf6deb21c74280ae864155e4aadd9db4a81"
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
