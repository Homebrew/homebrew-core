class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "43b0826a74c62b8de6e68263c749747a326962df04e173e492ac703188519a32"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dd4d4336878e473be3eb566a5700bbc503d65941a7a4214b12e96e302c330aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ed16538d2c2380a74e630aa927df85e301058737d6bbe78c9a99f581c19c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e61c5356ec3e40e78020f1a90701b8aa82d638fd2e9623aa5ea99b1deb8e3c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5bcea047dbb6822a68a61ca43631274e273c0503306251de5b0d6510c2c56fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "879baa2b298308cc67669368765c061cd37d795988f7fda7c2017ccf2252aafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f112e32f1c4f4c5f542ffb1f6bf27fae6aa12435b7b7252ff4e365502ce576"
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
