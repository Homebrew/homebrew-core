class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.0",
      revision: "9fd52e88d685edaae9cab872dacad75506a902f4"
  license "Apache-2.0"

  bottle do
    sha256 "b233fe8735838b37209137302821410750fb257c2b287e4d8b08a07163a92b5a" => :big_sur
    sha256 "bf1652d451eb70f0d5cf8b52cdf539b5df4012c32f12619022c9abc90f3dd58b" => :catalina
    sha256 "ee3a5040942a2679933c6b9a5522746dfc8033173e0b911c07e6d6c11a7ad16a" => :mojave
    sha256 "7ca3f1a22af748542e31873bc96307da643c47a51b0a9817c5d70ca85ee58182" => :high_sierra
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
