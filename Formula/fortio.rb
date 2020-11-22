class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.3",
      revision: "611806aadbdd1a27ba00a4adfee10e5868991e80"
  license "Apache-2.0"

  bottle do
    sha256 "f5932695d8160b0e53e10953fcdecabb2b4e5a3d58dad735edf5c39802043a43" => :big_sur
    sha256 "cede7d38deb5ad2994db53a1cccf8e3ae51b1b03a33ebeec2976236214c78ff0" => :catalina
    sha256 "13929c6a171062921930caf19eb6e395a0a3f1ace2adcb4ff2387dbc68570dc8" => :mojave
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
