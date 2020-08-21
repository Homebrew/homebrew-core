class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.6.8",
      revision: "55f745ffeee860b7dc4006474260627632fae388"
  license "Apache-2.0"

  bottle do
    sha256 "11717acac431b8722dcd8813017ebc021c8bb0a26e33ca34b6faca1c96c8ceff" => :catalina
    sha256 "e5ad5a3c860adcb6b572073721aec30a1df58c0d7f6e4a289d0b50bb52376519" => :mojave
    sha256 "92c276115300d93c09290c5b854bd541c714fcad8084918e54352e8f49ef5e2f" => :high_sierra
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
