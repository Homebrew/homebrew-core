class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.30.1",
      revision: "a5dbc975c3cd6585298ecc49361b2d7fcd185528"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff84ac1324060cfe1bf307e2e2bfa1666d95f72c6a5faf566e60cf2eef5dedf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14381e6411d3747adbc8403b027781b832b9dcf45d0ee390bf7707939b5a01e9"
    sha256 cellar: :any_skip_relocation, monterey:       "526c6f8a35f7fe596a1643871e478a205f7237fb1b8add0293658592e83ab402"
    sha256 cellar: :any_skip_relocation, big_sur:        "4722ada7476f3a62f1fda7a599a2f6e3cbcdb7f7bd12ffe3cfc652ce4fc93783"
    sha256 cellar: :any_skip_relocation, catalina:       "8938e3f7aad041ee7e349cec096c0f8b0a0fef509adca277de26ac55b0aaa177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e52a61c47d75e4d6b5a72686706cbcea90723309ca51e0c8e355f19faf6147f"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
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
