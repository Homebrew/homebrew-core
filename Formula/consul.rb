class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "253200fbf79aefee632c5cde9f90e6df6eddcb2766f2909b0d347c4438065126"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "751148f96c1b9e5b991d4f834cd7a41915c66ac1497f1c779828011e8a26ca94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f16fb52e8e14453fe283467725a72e5743dc97b0ffe04b8c8ed4cac46fa1039"
    sha256 cellar: :any_skip_relocation, monterey:       "4b34f763ff26746ceeecc21a5938af3fb190e11c818c6264a6358bc9e1f28ccd"
    sha256 cellar: :any_skip_relocation, big_sur:        "30dd1bf31ca92aef6ac9636c09f9fa11ba657669f1043761a7de13c88bd37343"
    sha256 cellar: :any_skip_relocation, catalina:       "e70e19fc796c206033ec8821653b20c2e9726f635cec2618c22c649321e4d71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb6e796e373e288ec8a6b9c773df08a94e6337509bc5210280c8d83552e8f3e"
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
