class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "d54e3aded1506f9189efecb2076a6b1bb4f065b5f1fa4be90a871c0c347b94d2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82670a1547e88e086841403e9f930856578f708f9975160d19043b44be429e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef6ccd8ce980d040af1caf7fa6cc68a3060403f5131431416b7390b25ca4735"
    sha256 cellar: :any_skip_relocation, monterey:       "d508825362eb59a5c8a10f5eced631af81391e30668c2d5e9da1d8353c8cd2a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "711d2ab076800b46c604070f206edd5c0f2386132da4134d0b8a6a4d837d3709"
    sha256 cellar: :any_skip_relocation, catalina:       "101f471299bfa5d7bfd0ed6718aec2ecb0a330b06d93a93d35c0c6b6ef3ab51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e74b2679d21e20b61e1b864c31d6cc966da0ebe2325e9efcac80e32295d611"
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
