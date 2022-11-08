class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.38.3",
      revision: "08dd2acc5743434a27962a811780786dcc9361f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129f5b8016e3017ba9a3b1d316a4a4bc0bb0d7a0fcacf70cc3c8118856ef29a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14e5675d9163774c8c8c2ceaa5e34b2440352a55408abcc29c1321016c6ba02c"
    sha256 cellar: :any_skip_relocation, monterey:       "ff71aca3e7c53f2e3ca0992d8628d9f2832d9c0e268e83149c727d3601ecd9ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "f923af7902aec36b319655ba639e0a4bccf0480ddeb372abc0f3f2f53116a793"
    sha256 cellar: :any_skip_relocation, catalina:       "8d380d7cbd835650688d0c32a1698a57ff3d2b6f4f9989cb80c95007d67f4e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4b8bff0003b5f3465824882118d19b56132ea5e95b8f2f065888520744c405"
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
