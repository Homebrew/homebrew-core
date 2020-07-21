class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.6.0",
      :revision => "bd290b6e205a7ebd5affb02279a15d634ab7b872"
  license "Apache-2.0"

  bottle do
    sha256 "e6dc92ee74bb13ae888e150bff58c1a843745a93ca74e0ba0ed3fbbd96a81894" => :catalina
    sha256 "f47588f3876a99d0e835705739dc28666bf5998a5f443643220fb6a81812a7e9" => :mojave
    sha256 "7ac86acbfc2b41c6518644b5bfb4a236674bf7afc80f1e15933c9404c9d5e2e7" => :high_sierra
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
