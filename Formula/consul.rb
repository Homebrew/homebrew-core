class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "dc071c3332908476ff1f0fce7b18af9767e19d1b8e499f62e1d2118f983138ae"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29569a893feb32ea6d2312e78ff0650d14d84c28d2bc7a4f34ca96708059300a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c88074b4bb7e1219f0352084f79f0cb3562ec4d05c088a6a277952767e2ad8a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "659e832d19547d69b20f3f5c97023d5564c6397255ea3b6fff36c9da04f51eeb"
    sha256 cellar: :any_skip_relocation, ventura:        "330760d709abed2e220be0f10ccde96c8050f9586a7ce5a31d0fa196d482facb"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ec5484f2fbf8064556cfa9cd81f732565756384804612df38be03f92805cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c83d20bf568c2315697019b6a8aca5a097e5f4d16ee4696fb1efe4bea67f546f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e64ac95ff9412e5032411667e8201f4e69ab0a70c9ede74a4ccd78c6d67d410"
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
