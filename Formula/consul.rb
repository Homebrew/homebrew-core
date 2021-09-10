class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "db627a521f123e6ba4021864b187f0adcb1248a37badaafc67f8e59f69232143"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb2cfe661e24b3a42129cf35021563ccf67778d443bed32e1a5cf6753e66e2df"
    sha256 cellar: :any_skip_relocation, big_sur:       "58584e3117cac7f421bd210233b3882932d4556c3a75ef997bef73c735beac49"
    sha256 cellar: :any_skip_relocation, catalina:      "db0a636c306684b9029b44ceb57e1ec751cb20364623f5186c21b2c083e36672"
    sha256 cellar: :any_skip_relocation, mojave:        "986f040e9b5facbf691c4a282a8be9066c7f0ddf0e486ed8a081d776102a13e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7b3b5f7e9d42480d6d48fbfc70e8a8c65961874fd6e70fa81c7946a86a371d"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/hashicorp/consul/commit/e43cf462679b6fdd8b15ac7891747e970029ac4a.patch?full_index=1"
    sha256 "4f0edde54f0caa4c7290b17f2888159a4e0b462b5c890e3068a41d4c3582ca2f"
  end

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
