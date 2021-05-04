class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.15.2",
      revision: "aa2b513834a4f14f790d444f5a633f94e37ae622"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "8b4ce1b1aaf06495d183d64548bbd4477ee9c339ffa47d83c4454b3fa46ffe7a"
    sha256 big_sur:       "67f56cedcac8bd88603d650accf0b6acc49649e294828fc7dc65f4b6240e8741"
    sha256 catalina:      "f9b77d3ab6bc25ee84ba90d0ae05f807e3eb2a97f1c982cd091e2b723c514bbd"
    sha256 mojave:        "854b2ccc76f286ee9b9a6edb04d7c24bff9bd7d238004c64d4166ba6cbbea4f6"
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
