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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1094c6e229b6dc82a1ef5b873ca1efe53de937ba289afd428858b3cc3b5076c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fb39f2b2122c2bb9b0f29b19ab8e7aaf33c263b74fc3b76a4779fe68c5d7037"
    sha256 cellar: :any_skip_relocation, catalina:      "279f93c35defe207c789d6643b15762d33ca67365691a6b1c22377825771263a"
    sha256 cellar: :any_skip_relocation, mojave:        "5b55eeaaef28b9c3bf356807049fe0ba5f4c090e810f3e291d976697ad1425c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e2e9e442d7e8c306bd06add0189ed964fba340e754197d5a64eb1f9ae7e319"
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
