class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.52.0",
      revision: "142cf8c8755d090704007690a4810d9ea7f83d6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e2f6783b6f78a90f42a8d9343eefc9df43379443c5e95f96b0e497cb8e35627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b56bd5ca8a0727408c3d50a3af0354efc5fc6fa16e4ad3b6005b6858822eeec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa9da173dce1b58f2b57f0ffcb564c33daf12d3585ed2e9c3d49a1277d69a6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "63d7d07b2d1964e0085996de743ca66b37853092fe9370f83c1938cc8766cd5f"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5994527b01867e2344b0cc2a56ab5ca50456fee6d0acc09c0da531b83c0d47"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9b590ecd0ac6fd7b64e9454d9f9ab3b6f597b42a78cca6bbac3c89f659c6606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652d7caca3467a4cf3611061533f29d381f933fb293745240e4a7d39f4d493b4"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

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
