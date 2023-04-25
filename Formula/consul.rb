class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "ce5e6666c9bd3ee8dcd60b2ed6e082ab9893fda3c0a2218add649c197f34f2f3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec49635056c1b199dd1d78841f39da706f6099df5f65267f5ce61df97b11b070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "805349e6eeb5cdb1892b1d68ae438c8c045dcd252873d13ea1fdfab527fd16c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c70bd3e75d4c9102664870fa20c77cea97a6ef816d045c170254d42befce6773"
    sha256 cellar: :any_skip_relocation, ventura:        "a733a7305168457948c5dee53058b72ff2ca2100e575a7ad5944ea3f80dc7cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "b8ffd436a13526201f813c8ae0d1edef328718d2dc4cfb859a8c060301bb3fd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "83f750c982b5847de776f377b9f47bf619dd2239f0d22fe452db73c6b01d228b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d9ad6713af388ae988ab56e60466606181be0407f8a27927d3b33a30adfc78"
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
