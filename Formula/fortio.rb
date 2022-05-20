class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.31.0",
      revision: "a9397d43c1e2081cc15c6ccae93d08542f9801d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90c26641580be99d1c623eade3761de5cf8252c6c731be633011b71a309b7ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "662cabee3960f3cc79d5eede1aa2732edfd586ada2375b8b8bdd80d174848ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "628a61be6b9b823591b860e596076cc62276c3e9ab736241c36e8a4da223f945"
    sha256 cellar: :any_skip_relocation, big_sur:        "5016721e803890efcbde4b2779e8deb8fe5ae2333a6448f0e35ac0d8ef766294"
    sha256 cellar: :any_skip_relocation, catalina:       "3265182b3c7a87b5c6241059ca8de94271df704eab16a8527da9e4a995892f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f33cf929c7b58907e6c97f840055a6ac6145ad38140d7be47b0703eccb29b11"
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
