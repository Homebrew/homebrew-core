class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.26.0",
      revision: "1219538d78b521e348bc2ba6d177049e7993f0a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1edfec0ab9fb2fea5434454c93af797e478231f9809f637d8a8fb9e40488a02b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dc3e508eb5eaa01a20be303a002795c43b474ed688505b924bef9ac7db512c6"
    sha256 cellar: :any_skip_relocation, monterey:       "590d2ea94d81078e1ba8be686920ffaa5e2f52f2dae0ae6fd8c65be10fda2d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eb52f59789165e9d78e79305cfba66c247f99b1168ebeb94a678d648bfb43b6"
    sha256 cellar: :any_skip_relocation, catalina:       "c66eb4ef443b95067d166310095be368f4ceb6d06a6ecd72e9ff049e9c39ddd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03380cf33e28d0bf094443ee99c85546ad73d418a0ac9a2cbfd136ddd93eccdc"
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
