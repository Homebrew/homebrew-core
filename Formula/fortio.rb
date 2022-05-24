class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.32.0",
      revision: "642dc5ba79194deed3f82eee70b6367e3ab3122e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85d4d14b9327aa2671f69fd58c2c6a1a765defc243926598c9c8031fd04c4463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3482ea9101626f63e15d92477d8fa4517e0d1308c10afdfb31fa61928400e0c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9481f61a6c33238061fb011fa90b902990c57ecba6c503144d87e483703036"
    sha256 cellar: :any_skip_relocation, big_sur:        "71eb79a4329f93aa33aad0d5d9f7397b67d454255155bed9d16561abfcb8cfbe"
    sha256 cellar: :any_skip_relocation, catalina:       "25bc510126ba00b35ae46a13d941cc09bc383f0c9098cf69d34e52fa6a3923e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb939d94432deca9f8426c513c7406abb13030ecfb9a05943cd5a27f9259972b"
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
