class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.6.8",
      revision: "55f745ffeee860b7dc4006474260627632fae388"
  license "Apache-2.0"

  bottle do
    sha256 "f7d300df19352a45900b7e0cf9199ef9507a37f4f97e99e764627537aab3b751" => :catalina
    sha256 "24452c59e23335fd4767f26df3bd0529d761cdf80a694efa520cff6c43ecfd0d" => :mojave
    sha256 "3fa5b77b0b7fc149780d6e8372f7f3c0cb268e6f78577f0aa729dfcff9218835" => :high_sierra
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
