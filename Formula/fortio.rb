class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.4.4",
      :revision => "5840a17ec92d01f2969f354cabf9615339eb8286"
  license "Apache-2.0"

  bottle do
    sha256 "fe0ec862f45d86697b4fc0ac4bf8eb300cd067518dd9e4637b8f74d53489a118" => :catalina
    sha256 "cd2976a94de5c937a0c4fd2c071fb60eb0e045c98e0ef20c718220bb46b82908" => :mojave
    sha256 "ef7a2dc8a0a67c8a731c5388e9431df82e7517b3f5392510b6649076602363e9" => :high_sierra
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
