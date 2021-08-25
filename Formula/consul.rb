class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "c840ba7b52df3ec6105a7febe900e52dde504a33bd1fa4e2e1985a88b6072d41"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfa296b80c62e1b65e08a35377006fa13f7e08d3c4bf08927bf17415d5f76e76"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ad0aaae9a9383437df77a9914fd55936d33c98f40f85868c190741fb8446f1b"
    sha256 cellar: :any_skip_relocation, catalina:      "ffb5d14e56cc6474ef68014d060eaffb107dc32cae89c2dbbfa5a1a8e4ecd4e4"
    sha256 cellar: :any_skip_relocation, mojave:        "cf0ebdbd3b73ef08e238da3d077553834a5503066022be851e900c793b8fc7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1cfb622303c035d5d4eff8aefd59003c466fcb090aec0c3859bceb45952008e"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/hashicorp/consul/commit/e43cf462679b6fdd8b15ac7891747e970029ac4a.patch?full_index=1"
    sha256 "4f0edde54f0caa4c7290b17f2888159a4e0b462b5c890e3068a41d4c3582ca2f"
  end

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
