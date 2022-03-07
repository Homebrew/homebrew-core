class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.21.1",
      revision: "7965771ec8feec9de2e1c6a3752c594aee7350b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f0a84c6d6613bfecb58d3784430c81631a9c767f7233d7cb8e1d6bc70c5ada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b0e0430cc2aaee5e5f78da3d22f3770c5a2894b7557c69ae229896f684eec75"
    sha256 cellar: :any_skip_relocation, monterey:       "d0cb06b2b9c5135486c677a88c524636179168f5e16eaed5d3727aa9b681be32"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6d98c064b2bbcc8bbdd24f74d57b1e814ea4445d746edd697c28f10036c02d"
    sha256 cellar: :any_skip_relocation, catalina:       "077dca3d4006de31f11bc3660e5d9e58b845b779867297968d0d40a0163e037f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55dbf4f8b3bbef2de917cfa3d902bb80255d7e55cae673fa5d04719257b4a939"
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
