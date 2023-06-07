class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "5137e9831b4bc094c8ce5be64c661dc0d9a96ee9509d756030d60d4bcca42503"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da6f00e68b4216f196217a8adb4ab0ba3c81bf860f922ad88b423b4dbc2bfab2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2693a583341b3ef61d9185344d577ea6ba53b1363573a8b65655334ed4afac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6442b140b010c5d4153c89505687a804e6dbccaf162f060b144db04593b2071"
    sha256 cellar: :any_skip_relocation, ventura:        "346b990d193fe8ce38a76fbb3a8544c7a0b42a6bcebf0eb5e68318daf3e54b64"
    sha256 cellar: :any_skip_relocation, monterey:       "046301cdf3ca0d05739f332b08268156f5a101fa3a5397456fd41425d5f5506a"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf2a0ac58311a640c886e8a246aebd98db6102a53f9da416f1c7bb58c356d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1fbf61a7fa8647170623f1087a11bb83bc5ce08d065a817475a04acededb12d"
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

    system bin/"consul", "leave", "-http-addr", "127.0.0.1:#{http_port}"
  end
end
