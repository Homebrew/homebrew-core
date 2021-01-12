class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.5",
      revision: "696d6ace5d1ac8535ee5e49b20bcfa9a779035e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "7abc5fc9821fb5247e4904b565303e4df7576fdf51a768179324b803eb48c2af" => :big_sur
    sha256 "9513e525fc8c109ad78fa2e6469a989d61df1ee25765058c3689eadd5f0f960d" => :arm64_big_sur
    sha256 "d8d2481d518527632bbd376fc86742a84f5e4214f68fed1497d94e4f2ba0ea01" => :catalina
    sha256 "99d1d9593eee47c5317a26e1ef796f16d8c6bb13e0bad8cfa7588b337afccabf" => :mojave
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
