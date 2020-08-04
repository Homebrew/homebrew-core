class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.6.4",
      revision: "de2ab6bb548169c78f36122034c980af11d2e43e"
  license "Apache-2.0"

  bottle do
    sha256 "d868e5f17b4d66dcca9213f3222b9a7c03a9ebadffc5358958e462dbb58303a7" => :catalina
    sha256 "000b2147d68f48918a61427d65489f6e32abe97ad741fef6eb957e23f8a107f6" => :mojave
    sha256 "bb9e47226f7f10e173f7ffe6b4bceea6c0838f015504c6e65a6b5aa65c2e843a" => :high_sierra
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
