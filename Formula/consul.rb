class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "87b3fe01d0a772dc1cbab31cf38ab05d651d93cd1632aa289faf06988a65d617"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f39a4ad0e91a3f9936651d54415fcb39f54b6fe3b825cd3c8d4daf72a1b0b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64172c355e3947d79b8f8b5cd7a93aed1574cc00242f5c219564f83cc31ccd14"
    sha256 cellar: :any_skip_relocation, monterey:       "135139df9816d07acb4fa7a9b2faeb9cec6f13d5e33c0ff64f5484dbbed2e527"
    sha256 cellar: :any_skip_relocation, big_sur:        "d97cf4bfb3499bc6cb26e0c07129f08442645f6cca9441b12e9bd4949b116b05"
    sha256 cellar: :any_skip_relocation, catalina:       "a86e7f955578d5e9115cca11e0e4d335bf50b9a9abd7dc10318d1e7176a6ff9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ad52671b971b12fab8acdfbda4eabc960d894217cf011b200f911d6cf92439"
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
