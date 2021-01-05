class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.5",
      revision: "696d6ace5d1ac8535ee5e49b20bcfa9a779035e2"
  license "Apache-2.0"

  bottle do
    sha256 "dc3dcac1c7007b2b21dd9105c55505cb1b6f86149be1242ac413baa0a361feb4" => :big_sur
    sha256 "8df5eecd8bff63c24abc875c6977cf5a1e548f8a52f12e9ffc64f8650fdeaaae" => :arm64_big_sur
    sha256 "41a9b9b4ddb5729ee114dfb42e305f558260c055d786bd1b17cc837344bff1d0" => :catalina
    sha256 "eb37c04b1d2bcdf1237fdf75fcbf0c83a274f4027b532b2eb6a9e62fe63f39d7" => :mojave
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
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
