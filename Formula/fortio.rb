class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.17.0",
      revision: "2d52633138d540a33a14d641d7470a998e424c6e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e36df84fc9f27fcb185b928578011de490f09696cf9d6c42e45fde88c895e2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "52f0ae2dcb229904142d93ecfbd053f5ef3a3b28df118625e8516b7e5af57635"
    sha256 cellar: :any_skip_relocation, catalina:      "72be3944ede1dc33bf377db6693920dbd3f7d667ad61d8b1ee50d4c4c64b65a6"
    sha256 cellar: :any_skip_relocation, mojave:        "396c971624a6adf19b6b0bb8788190a592dae099af38e841d23278e4b46aab42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40c95c4df6a6737eb5ed12bb03c34695ecfedef40f1245893e74b9eb1b3a892"
  end

  depends_on "go" => :build

  def install
    system "make", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio"
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
