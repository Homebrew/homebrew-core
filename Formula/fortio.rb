class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.6.1",
      :revision => "060ad6163d5348167c5c9030ac70564ce6167e96"
  license "Apache-2.0"

  bottle do
    sha256 "209819c4782c37efc4be90706c02a1fc44fefa90fb96cd65da6a3e1fdff6c582" => :catalina
    sha256 "4a6cc18f3e81338f53f99abea1c196f8a200f23b798ff5ec1ef3ecb6a9a8f658" => :mojave
    sha256 "06eaf3a945e0b5bdcc50a2d6bb884398f9fe2f046fd9f3e0b86c0fcc6185762b" => :high_sierra
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
