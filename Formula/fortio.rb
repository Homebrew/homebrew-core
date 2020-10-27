class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.10.0",
      revision: "1de14245249346a71d2d05424616ff37c708a797"
  license "Apache-2.0"

  bottle do
    sha256 "b3a43ddc63caa2b34fcbd022d4713d7801cb82954b9a2a954215bfbf14232bc4" => :catalina
    sha256 "cf75148bb6293e3f7f34c860016f3793c720f9ce97bb15f52a8efa7af052ffbf" => :mojave
    sha256 "de5a3d01f1cb0611c567d93bd03edd74ec5c41c173cfb11ec3985985ef7a187b" => :high_sierra
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
