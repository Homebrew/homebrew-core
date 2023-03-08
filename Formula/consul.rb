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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08f1c669520487fa699302cbde84458d5926efc4eae18334767935307e148fbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6617af364cafa7e51be6beea3bb84dedbf6d28dd63278686c29706007d44af7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a3dc37b98bddc5bd412ef60917f4ebde636c1134bdbe6c885aa165d392c0a09"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a5443a6f2cee78eab874bb960d5c1d78967031dd1fb41b8bacc7e5c5aad4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3cfc75764affe8c64a6d6336e6476fd9b3c6e72e5db695f1cb5b4cdd4d50d30a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f735be5ff363a474febe71d3bcdeba292c203c7f158bdad6f1cbdae89c2b5dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac4e1e8e2cec6c5d2f6bb07ecdc334c80f5f85b454a997c27cf4594c758c18e"
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
