class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "23463ebe297cd1254b28fbf19d5b32b52e7dd0784be3a5d135a63d48fc02b36d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe91bcbaff9ea909420359388253a0e8722d70cc2b2fb1a7eb7191a4aa4fc4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc032927b85fe8dd86f5e6ef89adec434a808b2cca1cda5f8cc801622da9a110"
    sha256 cellar: :any_skip_relocation, monterey:       "8abbe8da1ca76858932edc65258bb61f01fbe587349801c8621a38d46f47bc6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e1af338b87a2600a01e70fdc5abac618d6c62835af2e36c4759d92db3a0dc5"
    sha256 cellar: :any_skip_relocation, catalina:       "8291e603483752a1ab7bdf0b92ab3deefa630e983817d75a8875b62c382e3199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728886195033ddd34bd76292b7388cd55e37c08e3d38bb20a010ad04479e846b"
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
