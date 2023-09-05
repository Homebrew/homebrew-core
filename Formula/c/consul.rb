class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  # NOTE: Do not bump to 1.17.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/consul/pull/18443
  # https://github.com/hashicorp/consul/pull/18479
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "9fec1683131ff122a43512f265131729e20212e26353d017805c5566dfec2333"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a528094148fbdc829265a5ca617bbeaa12715d3952518900bf1d33b6377dd7be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a060a5e46eb086380dcc089c83878a7571355f285b91bb6a3327f3aec53d64ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "040d992ebe28c8cf7bb1bfbf0c0d34977a625b096cd1efb9323fbda4c56a0df3"
    sha256 cellar: :any_skip_relocation, ventura:        "523bd720e25ca11097ff5e33700f2496bb19ba30ca2cf59d25d08c4ffbc40129"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8990307d24720edffdbf6087f4e3b107cc60ceaf1027644fbfc42332feb4e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "de61aeda80b42d85433ef211f5d999711b48c7fef6d9d5926b504ae13298cc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3ea512a0a91c57707d60049ea99e734dbb543fd2ddbbecf0b9c16b09d6cace"
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
