class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.16.0",
      revision: "b0c080f6157c7afcb491445eadd64a323c617c84"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "11658c3a62e4183a04390fd4d307c5b84f8991442029727c1511ba596c209c51"
    sha256 big_sur:       "70122ccd558ce8b184696062d14aba344afb2613dce5b0e7e67c7a447cc9fded"
    sha256 catalina:      "cab4e96eb8699a7b22e02e988634fc792daed40d6049e0830280cb5c71eddc74"
    sha256 mojave:        "cc109c242c6ae2daafbf5b02dc058d7359883e9b4a49234e2add7682d704b587"
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
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
