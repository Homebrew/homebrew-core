class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.38.2",
      revision: "d2a2d42f4f17df4c09e608353546ebd0d443747d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3f33fc77160efb98990d52c18c247616ea61a43a88726ba3adeac3807f33443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9b997df97eceb39af372e56f59a8a5ed2f4d8aaaef255db5966466bb9463ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b87ebe1f9b0fa8e00357102c41666d582cc1b555ad2098896414c39a5bdca744"
    sha256 cellar: :any_skip_relocation, monterey:       "df9242d6bba0ad5bfd61a5de94be93ff28e4fc9f64541de246640d0c30ac9f46"
    sha256 cellar: :any_skip_relocation, big_sur:        "e190c9e86399aadf2243e901f12d4ad4e781a9d48ec243699b458061079b2b47"
    sha256 cellar: :any_skip_relocation, catalina:       "0fb77d438399d1b9ea30018ef7b60f8ed533fbda00d1e540c88ded2eb7179545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b436677fce78fe57aed2dca73042cdba4586f32825c4155a298b50248295afe6"
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
