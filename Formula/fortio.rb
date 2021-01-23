class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.12.2",
      revision: "c0710e833628b3da20f690eb6bab4bdcf3c101af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "eaccb010eb426c347d8e704aaadfea73073e971ba0447815e1839324329d8184" => :big_sur
    sha256 "83c715557c43cc9c1b401114a59eaa76b333e33d5b51897ce9b2e1b55bd26602" => :arm64_big_sur
    sha256 "1fa8bdfe5da2b88ee3535f8d9d537089e0487bfe182c958525cc6fbeecac593d" => :catalina
    sha256 "62ac9444b0a79bdef28763c58aef2b39c3484bc5373e30ebebeba418add297c6" => :mojave
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
