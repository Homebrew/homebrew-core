class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.37.1",
      revision: "0fa89821fab2d9451802ea6195b721d4a94d65a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ce40fbc5e5df31e10194dc38152c09f97290a6490903f4f6e365940f3b4137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1615156113f503a1bd1d5242c5633b61ab4739066dfc4832f4f816c8e93f201f"
    sha256 cellar: :any_skip_relocation, monterey:       "32b943a0fe8b60695d807622de75a6cf5783665720a6ca8f724d09c2b274cf59"
    sha256 cellar: :any_skip_relocation, big_sur:        "6600897683339022a70ad20f547d961c9c915150b2bc6336b85ecbe6b9bbb58e"
    sha256 cellar: :any_skip_relocation, catalina:       "9f4fd4bd156a3a74e5a2d3cc488a53ce729f1c5aae846be0fdcfe75fd73765d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5992d4e9c98777f9134bd1b8e97c95c00e8c0bf60d9b83c6e24cddd05feb8d47"
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
