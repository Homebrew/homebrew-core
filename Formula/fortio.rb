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
    sha256 "c2ad2f0509ae864d216c5dd3ee8d5156ceecbf4a572697b20c1466f835bcbfa5" => :big_sur
    sha256 "ce39a9adfc7af3b47e03b497cb2f868aa0623eb4496454595cbe362127d22334" => :arm64_big_sur
    sha256 "7fc5cf06083d9eef40348742fe5bb43316bfeaa16fb72bd06127e2bc2c70f202" => :catalina
    sha256 "e112792012f33e671dd9423741bb9f5886558e2216d7f5ea76cfcbdf72e4f101" => :mojave
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
