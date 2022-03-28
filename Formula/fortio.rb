class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.24.0",
      revision: "fb00657cd46406b6660f5fc1fa4894d6c426d295"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6cb159df50efe0cebd9406ef4dd95edccac8297e4b2f50fd6e2c254c34b4308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7b92f2b1f27388f083c9ad9fcc28b893871acd8248a44f3f381889d16b607e6"
    sha256 cellar: :any_skip_relocation, monterey:       "b5343250a36236dc058ed84a8e38eb85422d8204993fae0b1a455cf0651fd1e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "28cf09c0c8c8433cb55186c294e95ad4e9c75d46b6740e4fef502ed10999f23b"
    sha256 cellar: :any_skip_relocation, catalina:       "a082eaf6d607b4bf176e98596e826fafae33178126ffe3b2738706acf0908589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a255bb277c1bebfb79ae2c95c1bc658dfcd6accd05adee2eb4049ecc2c9c8f"
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
