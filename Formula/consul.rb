class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "6e3da1fb589586af4d68b2e924ccdb9f4aad644826aae452c31744c658eb66e4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6701ad9b8652c3487bc3561383d41d3d61d556c863052109d077e6b63d3c0ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c883579980eeaa29b7fbbf8c0c8ea024310fd38ad0fd4188a64dc552690ab6"
    sha256 cellar: :any_skip_relocation, monterey:       "324ccb130438e0486426c3b7bf07629089f386f0380eacb9ed6151692d85d937"
    sha256 cellar: :any_skip_relocation, big_sur:        "3270fd47e75ffef527dcb8360d6e73a0bb44a9dee2dc1aceda2cb0385886ce5b"
    sha256 cellar: :any_skip_relocation, catalina:       "c67e5fc2ad0d55fe9f55d1e8de64b2b355ce13b77f12a16775b81ada03d16737"
    sha256 cellar: :any_skip_relocation, mojave:         "b3d551d48fe949ee3af2addf98e96aced37722122798d42775d167873df48aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2187746a484810e520d49f4e85dd7a4d84e45e88ced001f5be5eac5d641682ff"
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
