class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.32.2",
      revision: "6b4e2d4870971679f0b586ad1082ad0b9fb4b162"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0773689185a8fdab391fdfe2c751cff49cae4da8e047268ab2a65522ff1edada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9024d01dd1c8e7e102300891dc2498d31a3762dafb4f0a33c51d2cc83d4be5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "fe65c60a305a917f794003fe1d62e961cbe9eb8b00217e53d03d9ef795c42d45"
    sha256 cellar: :any_skip_relocation, big_sur:        "97182c4e0f97cfbc0851dc892844a2ba6106404236ced8fec6507455d34891e5"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4a8878e7622c38c69b089a77cee599f472f613ba00401bcf7da11b0771e7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4afa6e5ecffeedb88407d226775d987fb242b062c2bf12f982ef37b09f2719"
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
