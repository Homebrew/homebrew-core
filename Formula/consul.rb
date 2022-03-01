class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "253200fbf79aefee632c5cde9f90e6df6eddcb2766f2909b0d347c4438065126"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ff3c2fc57467077eab10722250f8847fa463be3b4cfa1b595288da9bd8b13d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f4b39d7748055e47da96ef0e846c6811d1833b3a3ea1741fd162a94b44e853"
    sha256 cellar: :any_skip_relocation, monterey:       "ddddba19df710e13b76362d98dfae9966accf9e9c1ef8ffe16437f3609899cf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ec6ffea670d0fa9bf1f1acbba1c55b438f2b7407094ac8a9c5f124620c6a01b"
    sha256 cellar: :any_skip_relocation, catalina:       "3039a78440681c555b84c44c11ff5797796963482766121a0a3c782be0a54a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7cbcd958079d386c7deb795c0783f57bb932ea8cf962326dda4f3519c446518"
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
