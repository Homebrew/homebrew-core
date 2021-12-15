class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "e548902d6a9c92bcc07fc1af33049078fb34a371e9853be6b0d6a69cf2a2c208"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a60738af93716ff2b6a9854807b860fdba136103842bac86a89ef85c7ec9e45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6441ddc1f8b09abccbba46cdf8e82e71988ec45102523ec3a035dd5bed34d8c6"
    sha256 cellar: :any_skip_relocation, monterey:       "1d25b615dce8df3834de0e2b10e0064f49686dec0d8aefcd9dc5f615f293db4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e92fbfc163c5c30095ab3e8189ceff85f1a384be107851c17b5b3aacc3e9ac"
    sha256 cellar: :any_skip_relocation, catalina:       "5463a6ba3a54af80dc3929f245f9fef634cf39c26ad7b424170c1cce4d58dd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749f78139cab5e839aecf965f48453933a69e80f304059a46abe1bc344a11e67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"consul", "agent", "-dev", "-bind", "127.0.0.1"]
    keep_alive true
    error_log_path var/"log/consul.log"
    log_path var/"log/consul.log"
    working_dir var
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        bin/"consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system bin/"consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output(bin/"consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp
  end
end
