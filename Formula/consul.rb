class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "c840ba7b52df3ec6105a7febe900e52dde504a33bd1fa4e2e1985a88b6072d41"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a3369f9f96d35fbfa18d04c3e9e38c82cbb79e6bd0d58dd14bf65e282f510af"
    sha256 cellar: :any_skip_relocation, big_sur:       "428501ad054c955587c9630f611ad317c45c07c20981e70bc746a4dab427c554"
    sha256 cellar: :any_skip_relocation, catalina:      "63138480100a43016bbdd31daf45aa179bff8a80b2175bd606934b640dede838"
    sha256 cellar: :any_skip_relocation, mojave:        "bdab7d79a9f4198e2ae4328687ee10815100ed47346bed66738316745fd8b8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc3a46a05bdce03cc41795203df5d9682502e315d9b3b862053f1dd7596c9fb"
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
        "#{bin}/consul",
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
    system "#{bin}/consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output("#{bin}/consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp
  end
end
