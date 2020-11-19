class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.2",
      revision: "1d1ffb103b891e3d2ba62b8ab20974b04f5b0402"
  license "Apache-2.0"

  bottle do
    sha256 "57635b1e1844ca0efd146d048413cdaec87330b29ff8a9954adeaaf935e2507e" => :big_sur
    sha256 "645938e4e26866940498119f39468a21e4327fb2ea1c459f39e247f92b6ec4f9" => :catalina
    sha256 "40638060effcaa64e249824fab1eaf87c46862f2598afe05c33571570b1a0c88" => :mojave
    sha256 "d3626bbe58095bc43f65a4ce2175a0cb3bd37c5e60106272022332d7d964c42a" => :high_sierra
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
