class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.37.0",
      revision: "0d61b4f7a69dbd3f3de7558063dda80033d35826"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e39f3fe8250e1b719a026e46ad06a3cfcdbf49ab9dd607ba1e7fa7c603512bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae898e67ea69d83446b4ec9523f7456e0ed2bc391d5ebf8c3e03ee72a60c9f73"
    sha256 cellar: :any_skip_relocation, monterey:       "85c539582f8bdf24bf3885a08c1feef621c8513d274f03fe65a54688128b4152"
    sha256 cellar: :any_skip_relocation, big_sur:        "12eec42e7217bf7ab9d4b7257cfbba3160224b1debf13f8f33b0230d597984c9"
    sha256 cellar: :any_skip_relocation, catalina:       "ff2dae07686c9f84dc45511a0673c9d2e3503d7e400a747e6019b263fe6318f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccc68e90728994f69c489a1761494f007ae67855d411db3f5467ebd05e60900"
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
