class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "74d627b778760d8f0a77f65742c3fd1e07bef18e8ce1710dd7791032072b4029"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87103e4d613d7ec4b87a0e9e2e4da752d5a07e46c6a526b3e1ac8a3b31989926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab6df5fabe3cad80243a429a27ede1ab3589632421089aaf230bb3866c921e2e"
    sha256 cellar: :any_skip_relocation, monterey:       "10f597b239a6c5d598e3eb100ab392171046c53609acbdf684db78a6791d1c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "3311c6837b476ae5ef5925f29278a2d372244396da68f3874a97a6954700eef7"
    sha256 cellar: :any_skip_relocation, catalina:       "9559d0ce71cd47f5f2c6cc242f4f57b1b00f84ffd6845772d7bf3d9789903b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3b9245555c1482a4af50aa4a29978933e931b1a39099c6940b8b23ddb9f015"
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
