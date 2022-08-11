class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "ebb09d8f27b11299d4000cfe59aa95eac80a9301cc1d962ad3c673a566b70af6"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd0624182648a622feffd8994e462e2277e5000bc0c18d7cd77ac72e8d27b1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "341a0610ebdd3eeed8016662d34d0e9b5e2e2da46ca0787bf0f3c17fe3ec518e"
    sha256 cellar: :any_skip_relocation, monterey:       "650215b19c327c40f4aea405a82943265a980dd90ae67cef3e5d893ac0ddc62d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08183438346ce170fd053502898f6121b58ce363c6a9823bd7ae3b0428e15fa"
    sha256 cellar: :any_skip_relocation, catalina:       "9a73e0c97eab2196e7ebf1a7485aea18ec720535d4a02c6ed9f64c57357e5582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a7129e2e32e68e3ae05c656afb2f9938dd56bea42300f64620654161214b25"
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
