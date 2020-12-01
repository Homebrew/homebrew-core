class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.11.4",
      revision: "6dd1b178adba1a28da7e20e8a0be4dc32ea7a048"
  license "Apache-2.0"

  bottle do
    sha256 "bcf9a1c21d97a374f7a4f71ada268dff41082ce4a13b72dc51e6eaffaae3019d" => :big_sur
    sha256 "a947f37d61ddc59b0d92ba631e738ea91c1c61cec4dc3216cf3d6bcc32ca7ae9" => :catalina
    sha256 "d722fb8e5c705150cf3733a4920140a55f1ec31451a17f69f28d15198345cd67" => :mojave
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
