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
    sha256 arm64_big_sur: "91ee18bcccc55e8394778d601f915af89d77b105c8cf6ddd9d9778f82667ab01"
    sha256 big_sur:       "2e6d31142f5f4ebd859d475e1aa6ab7d9b8146865e219e70f45cfe31f0575620"
    sha256 catalina:      "a8b990cf5059bf196909a341f468c21c49c46a3959186fb980d8bb29c0976cf5"
    sha256 mojave:        "75bd38b8e8804a7b7615abd0c71116f0d2c3d6fe1fa1c4ab2faa62e7775f46ef"
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
