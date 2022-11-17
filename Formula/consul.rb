class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "bdc3dc7e4d5d4448528e9bf6fee1cb3b613a0f730820988d4fc550e189bfd46c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4e073d5b5e016044a4e47d3dabdbe22cbb30f33da13f4412c2f41c2f1c0b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d167ce4266c1397e3905c2eceda4ca6e06a9e8e1bb651e47037fb0438a1d079a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e39a1e36a9ff85057372ce3cf642e7a7e097355cf21bd4b05ad955be36c7ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "977037f7e8cf7e845d03af2adbc2c8a848c63500ba50470b4cbb96f9c4dfdbc9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c79d9775ed7bdea9f0c41e50e5bad96aca8aee86085357352e6fb797c6a10a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8feb852c1f5f09617faee8aa7b82e61ee70d890b9b73aca7f8ea08ad761827d2"
    sha256 cellar: :any_skip_relocation, catalina:       "6143ff8b4a04cdde35d9b1933c087d13a0158f007ea078aac4fa6da5052f9bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ad31a4f93ee5bedbb9d2806c6bed1dbcf5a253cdcc3a01fb35d5c04df51100"
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
