class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.60.0",
      revision: "616c1dbb73fdab150cd59a9a7b43a307d08ba212"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640a7e12f3fbe722d13506ccc64d9e1fd3c8a93e328ef8d8f43e66d3eab74d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a2ded6bb842bb0079d4ed7a458a835f5f2d66965f26deea2c172139c126da2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45cc85df6d5f286d5b225b4edc8c0558f600365815dbb4a4ead5d24ed5deb178"
    sha256 cellar: :any_skip_relocation, ventura:        "85754ab83e3298a2670feade0c476e507316e6eefd7b152ba5ba08027a1744e9"
    sha256 cellar: :any_skip_relocation, monterey:       "176f7abb92306ed4c489e1a20fae650601eba14625c3dc536dff7966c2ef0a91"
    sha256 cellar: :any_skip_relocation, big_sur:        "2513736291065985ecc38d177aaae0cdb3246304efff80aace73bfa78e47c71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d688916cdf7d0769e35617218074a023781600a3806817bacc750eeae7c22e"
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
