class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.15.0",
      revision: "aa6d00b21c146b602af430bd85e7a3a514d40347"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "3610f39eb343fb5b7a73d8ce5f6893c3739871d4c53c15b148da277204e61946"
    sha256 big_sur:       "d4b6e17fbec3492790aee0560f4a77f85f5464c11b0b40ec933d617e74461c7b"
    sha256 catalina:      "3d42972667821ee5d0b149ec7bd990d75908ce54458c9a3dcf8d3c8a915326ad"
    sha256 mojave:        "0abdf2c221e547a3528b6343a8eaa8502fd1127ba73a3d15b59cc0007432a7a2"
  end

  depends_on "go" => :build

  def install
    system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio", "LIB_DIR=#{lib}"
    lib.install "ui/static", "ui/templates"
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
