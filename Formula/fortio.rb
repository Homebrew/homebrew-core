class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.20.0",
      revision: "4a325b93146c7faf5d7ff5a327d3c86abceb141f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c73210620f0001526a6d0c4306c2d439592de2127f5684690550197f509a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "709b73b9f7307818698ba08640f0daba382505614cba9c708a0b47d479520c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc425149da8a4a8c44b0f02657d5007a3d116518824df17e82af7aa4c9a6ef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ff0467a06149296a9ed9328eb3df352670102b090111eb9cfc6ab071a02a6d"
    sha256 cellar: :any_skip_relocation, catalina:       "ec25f5d4f26a1d81e4f2d9dd61124790a0f557473863c186c5cb7a9cac23dfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7bd5aa17b8a876c92640eb49a815ab03941f31617addbd4fd8f9c536982c17"
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
