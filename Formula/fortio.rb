class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.50.1",
      revision: "f7ca38b31431e8ae81e2ab343e6fef71dcdfae6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "737bb52219f1060c860b7867f729ae5070b2bb43fa073fa6eb4a6132b27ad316"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86d87dba3694e6cadf7987ef02eed5caa1daa632d1ac372f74abfe87f8ae8819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebcbc4afca2c625209538dccd1160401bd3bc301eb738c3cd2d1bf008a5bb732"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe4ed3e3856dce31c01fa6b413f52d074c328e03cc78baf0c51e9f451ca8637"
    sha256 cellar: :any_skip_relocation, monterey:       "a14d7f3ad1a878e76db40e34c3a8bc6cc35970a762a64bc1b204a39e4f232346"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1db6c932774560101f2dbfcd4c0114a95250b8709b16611421c4bb15f3a9375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09838c2daa2109b5f1a094a859b38a3008ed1a82c94d47a9b6ffc158eaf0aa5f"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
