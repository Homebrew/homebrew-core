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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45562efa4b2798ca60760f5d547bd986d62e1b5f34b4259740182210f3064860"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08ccf48b8a21b174db172bc4812b7e7825788ae60669124cee500e4ffa3c6af2"
    sha256 cellar: :any_skip_relocation, monterey:       "6de190c59c7f506785f0d4b285bb86a951c710f3000dc57a692e634e0e5d0f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba5f4258837c147a6a59f857417408cc16fa0ebf117c23018bf2e71119049eba"
    sha256 cellar: :any_skip_relocation, catalina:       "32f0a64e5fdf2cb7e3ec283b7b7df8ddebb55744d03a2906a894040f5dc4ae9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b5973d93d3621840e7cca38709f45749d68863861b7c4d6c175ca9abf0fb89"
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
