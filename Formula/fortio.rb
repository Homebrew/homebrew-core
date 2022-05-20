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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8824a6e4bea0842166f7c3087a4e10af0d2f9afffa45efccbf572f675e29b24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad59ecd6deaf1621bd1fcc75acfb2ebbeb4b9d528794cac16dcc8ebb99e1c7db"
    sha256 cellar: :any_skip_relocation, monterey:       "5d8f973a47e6f33c699912c02e39ef175439a9aabb8640c809e2a9170534b457"
    sha256 cellar: :any_skip_relocation, big_sur:        "86cc84b3d6ba3daffceec192ff07bdbd289946e8ec934d37d330ab7cb940a0db"
    sha256 cellar: :any_skip_relocation, catalina:       "610dced29087d9c4c1534646c2ddc46b05157442a9aff7d2808539b8707d81b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acb8975325990c1fb19314a954f57f735d656290c6cff9b692b4c2f44c600c1"
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
