class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.27.0",
      revision: "450fe3dfe6302e1430d8eb00d37b4386f83ffd6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c81d8ef1fc19e7463ac437face3b8bd0a8e22393a832d392e4c6633cbf66460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712702a9e24f006f3306d4063df248eb4cd1980b9c5ff6141ca1e1f6c344ac4a"
    sha256 cellar: :any_skip_relocation, monterey:       "04de351918c38d479096db6018158f8cee047635b77d918db7ba3b2254cf61b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e8edbb1421cdc257307152417b30d5390ef55af46a67f2a16e02fd2dcafffe9"
    sha256 cellar: :any_skip_relocation, catalina:       "fdbb013a95d8135def974874adba010a90692f1976805702acee7240e3c6c1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575f8f85688a51bdccbd9490a198d3ce9ee17531b58369e18d1419d45fde2d63"
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
