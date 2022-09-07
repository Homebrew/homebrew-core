class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.36.0",
      revision: "83ce66168fb0bd6958bf91cee578d818dd6671d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2c7c4384ae5d7c05c6990126365750b4ae884c7447b23b13a74abc8a414cda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86b0449f26a5554a2bd758561ed2ba7cd50ac04d7105569a6b131192a46b9729"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6fa4e714377c6fc296569bb7d1384c680b84fb7de420e9be29517c3c43e2d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f770dd3bba850dd233520c9232c89dd80e591bd58814dae5bbd89d1c1dc48c30"
    sha256 cellar: :any_skip_relocation, catalina:       "6e8a8764fa6d0245645da4cd4cffd81d605bba5ec33d306d149de1f31711a9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf36b94fb57fa5a7d400372181cd5773629164b23184aab88b436a2e6f431e4"
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
