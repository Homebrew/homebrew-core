class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.68.0",
      revision: "8c89ef3eb72c14c27bad8ef64804c6098ab5225b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f66a0443fc434835a3d2c7a22b7bb0c031166615a0280d1ba772ec0f9036f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31d8b3bd7f2e507f88954b4f232108da34a52d161abbea4219253f045bad344a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f45f2f61835b580488c307fa41e7429f29edc5663619a423aabc9da5c000fc5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b4bae25d875e7b8987d718c83839c97ebe500c697974659fb06fa501c6a3cc0"
    sha256 cellar: :any_skip_relocation, ventura:       "3e37ec7bf66f73dc58753a86db830d35ad8b5e7cc6965547d6e969f36a0d7ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb86192a218315713c57197bf5036c812476e8bf97cbdb5de85772586dc5592"
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
