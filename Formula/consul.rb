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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4b34e2c215b3c42ff0935a755ff732b53488e166410358defb44bdb3bcc3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "362e9171d469f61339b1bfb74c1c368a37628fd2687babd2a408a51b3e2d26a6"
    sha256 cellar: :any_skip_relocation, monterey:       "e135e662f24599319e0544ba21988f6b8db10f31c660adc64ede64899cc7aed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "12e3f11a9015738e750f112d8028e76354877957a43cc8b1cbb1a11427b03c53"
    sha256 cellar: :any_skip_relocation, catalina:       "0d5fccd0090101df8ecb8ec089aabcfe885e8ad619ecb6132be2f766586e833b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ad299d0d4e2d00a437efa4b5f982d230021679c338fe325cf4754d7cc6e46a"
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
