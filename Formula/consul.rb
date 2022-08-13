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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62321927f63c39c5a9a4d733926d5a952d6869ed046adccc69de127e1c10220b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bc5cfc60e260f16d2be3fda3ce3b2bb2188753de4d2c1b999746ae1eccfaace"
    sha256 cellar: :any_skip_relocation, monterey:       "6cb3599b18f66046dc3c598475827ca990c9e45f6a7f7a16d42e6019b9d03a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "45ec88427f4f2e65d4767f151e4b2431b84abba806c21dc8a8edcf3f9c24fdd4"
    sha256 cellar: :any_skip_relocation, catalina:       "ccbb0ee93a6e4f55cacbb6eac702f0107c62e9895003a3e697c3c66b3bcc48e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06fa198e4e80459a02ecd26c5b5fc4b8fad261cd9a507043e206a81fadd54e58"
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
