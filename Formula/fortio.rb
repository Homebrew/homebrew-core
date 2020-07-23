class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.6.3",
      :revision => "4313c5b0f2402188a7009ca89b2c8f72f799e866"
  license "Apache-2.0"

  bottle do
    sha256 "84829c8fcae6895752770842139ae4c583cc1ab0519fda59aafb800a8bc51270" => :catalina
    sha256 "15e87361e10bb68d4971b0b7ecc87bf54265817c769ff7617e847d7754318a6d" => :mojave
    sha256 "90a532e586b9a178e3507b7a8e981514a30562f3a360b1d8bf983b1aa918b899" => :high_sierra
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
