class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "3f5f698aad0343642949d1c442e6e8bbcd835e3c173e4ee8ebb087758d1e31a4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be59e21c4e596222992f53a8109b53351e935c5c41d26786b7f5a1300d696743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e18cf4e35a43e3c1c3b29c879629e8394999f5d0d86c69c57bf5a461659880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0463ae31c2cc8823986f2457f12cba0756e8b300025e4c832494b07f529aa8c"
    sha256 cellar: :any_skip_relocation, ventura:        "7cf851461057236b4bdb39823ee4b06a6ee63bf010ad97379e28e6b2757b1b69"
    sha256 cellar: :any_skip_relocation, monterey:       "022b48cb57bbb378173cf72a93c52e282a9bae192accd7528281b68d33d18395"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90c9a3ef9eb9da9713abc57caac4e4165819e90d6ba3194a17b42c646decc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d65b0b00c1da8581396de7624d59a9b93a7f9a78ddf737d5ed62cca5ffcc16e"
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
