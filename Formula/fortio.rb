class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.14.1",
      revision: "61f7f962466d35d0eeec397195c4180d4e73b50b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "ea19ec5712dd54f1b3e7a424c261e8b7fa4410114262ba5a01ca9bf4af4722e4"
    sha256 big_sur:       "3e9462bdfe45e8db2915ea23d63579b919d4cfd530a86c90803fd2d657a27cc5"
    sha256 catalina:      "69fbd3668e196b24a112f469aa15daeec5716ffbb04491234c455a916df5fdf3"
    sha256 mojave:        "b0a65fd0b090d4640ce84eac5c7e5aef612decb5252bd7eae60ea6e022435e9b"
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
