class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.54.3",
      revision: "c6665d10f24572d219ed90c65e011a4f8ffdc8d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f68e621cba3dda7bc09f1ae60b0d9387f46fbc114815ad0b61bea527a0dacad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d92b1d8e468d4fc4634edfca78d8daecc85400b295105a29a4ef3239890ed7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3209be8e5df75eddc90bb9df3c9309c2b4be3f5e9af6776c88ff8eaeb31f66df"
    sha256 cellar: :any_skip_relocation, ventura:        "f3209698ce3c657c76af5cb3510fee240a9b609c99ddddb5b70e00540aa215ef"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2d1e18ff1f25bcc26d6b179e009696628a81bd56ed1b5ead79687fd2fe2fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa7a3462c22c1eeb1b32ea0a64bd64dd1645765e4dafa48bc25b3d432f09e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fce4951bf960cd8fee71d850e0626e7bc117f3f1b369a7e8756348eee330eea"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

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
