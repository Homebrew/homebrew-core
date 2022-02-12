class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "1bbb45b6b81c23a0d9b02be2eb8a1f22c67837a72ba64d8ac9ca3d849fb82de2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4bc2b1b2c3d4f53a60828a7b47642939327d6f1c112ab822e8d99370d0c21f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf60a10db6d1884423d1972616acc3226b64894d6591010fe63306495e7dc4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "baf9bbff3628a2aaec14fe59fb78ab173560f403b1c66e0bb484e4dcfa969805"
    sha256 cellar: :any_skip_relocation, big_sur:        "555fd8717765b8e5e53853aa0f0cf5afda465242b245fd21a53d063f07e301ae"
    sha256 cellar: :any_skip_relocation, catalina:       "8e1bfb8aeaca7e4db027b14afaa6a0860a0c3e205594aa1456472dfa780dc5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa2c123ef63d45f1bba3ef80c3350d942787cadbcd08079ca8c4206d462079d"
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
