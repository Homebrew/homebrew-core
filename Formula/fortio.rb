class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.8.1",
      revision: "4f6bbfb57bf92e5dcdff2100d2fc4a3777d5a6d9"
  license "Apache-2.0"

  bottle do
    sha256 "417add724f9ce2c25ecd4c9d51f5a2ea8c8f47aa3e0eee14073d8484aa63470c" => :catalina
    sha256 "08641ce3940d51524eb1429008cbf27dec43d194799d99d4bb979b87dab00fc2" => :mojave
    sha256 "227a5f28fb2ca38eb404cae9712b040da3c86d7449e921e20179f2d0dd086d85" => :high_sierra
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
