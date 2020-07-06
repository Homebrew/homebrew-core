class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.4.1",
      :revision => "11f2dececb6ac224ca492f01b02a82f48f94f8c2"
  license "Apache-2.0"

  bottle do
    sha256 "2cd5f952ee237726111ca74eabafe3fe8d6919c7cb80d88ccbc9b9fff3879005" => :catalina
    sha256 "ad39cabb8431d494e792b876cc5e65e0b2435017efde93f2f2377ecbd7aa0d17" => :mojave
    sha256 "7a2409781ec75daad59705b014a4357dd503c05037b02c18bd7b853a94eeea75" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/fortio.org/fortio").install buildpath.children
    cd "src/fortio.org/fortio" do
      system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio",
             "LIB_DIR=#{lib}"
      lib.install "ui/static", "ui/templates"
      prefix.install_metafiles
    end
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
