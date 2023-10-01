class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.60.1",
      revision: "dcad10f29dab524eeb5a94c3037a63d04f101310"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f33bc4e3ae7f5a33c60ec534c095f4a1649d89cce38ff917049da3b74f8051c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12aa44ed41f43cbc53b22b08414338feb9167fb4dbc5600c79326c5750c5189b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fe3f6acb4912ecbe778de949867b7f7ebdd01474d544ab80b421ffc790816bd"
    sha256 cellar: :any_skip_relocation, ventura:        "f039f239518c02c54ae26186977943870e7fa6e1706a7462ce3135f76bda1b97"
    sha256 cellar: :any_skip_relocation, monterey:       "d7839c122bed826924dcb97caabae3651f0d5d44d067a149cb9fa1052f0c2d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "1212eae43914a70be622c801912b83c39403b1e91096eb498e00baf5b52405df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4ba77a2e49a9ade801823c4f8c74d6d4540dacdf74363ea54cf52c2a2f53ec0"
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
