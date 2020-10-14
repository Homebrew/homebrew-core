class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.10.0",
      revision: "1de14245249346a71d2d05424616ff37c708a797"
  license "Apache-2.0"

  bottle do
    sha256 "6d67c1800be16169d1ab2a60f72ceac27ae7016b190119d41707abe1ad8712bb" => :catalina
    sha256 "586608e14582abf448a68bddd3e4526e0e3a04713d07838e5355b28d53c9b68d" => :mojave
    sha256 "8e3ebd1241cecafb1b2c2c55a64ad3a2da5fabe830c8f53b1f6a66c599aba89b" => :high_sierra
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
