class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.22.0",
      revision: "b0adf910295107f689dcca6afb9fe2b397cbb977"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6317c6b9b96a306ec689faa4dd6df2fa835199ac89db6f454909817f26cf4859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0748120d7054ea32031586db76022991f51d91b60ffe275a675489a45d0ba2df"
    sha256 cellar: :any_skip_relocation, monterey:       "f0135a409d7bc56afa7bfbb4f988c1ed05a12985cb3007f14521cd2c0268d0e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "174d8ca5a1d97d0b340b4c8e4fae2885a6d6101db309c67c0e64b92500ab08a0"
    sha256 cellar: :any_skip_relocation, catalina:       "b2662d3fd731f803c960d394f14ec55c53890678cd91c693ba6507bf74ab6621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f14ef5a3074a89b2957ffa1f6246893bf6d2a68b14b4a35ca361f768d9a9fbe9"
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
