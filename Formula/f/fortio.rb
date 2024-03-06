class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.4",
      revision: "b65de249059a5c0cbd1c748729b924f91432d410"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7984e9d1fdcf11c7fd40c049aa4cba9c1cb595277bf56948909673e31698b3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c259b88d2c1240bef5e563971a6ae9cebbdb9ff99e40245304a74da76e8d6a5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e359bd52800fa708628a86b0e75c3dc405fa8b85295ec58fa6c96a73b9bf34be"
    sha256 cellar: :any_skip_relocation, sonoma:         "24dc0f4ead78eca5cb751f3231675413c1438fac72233cbd3c7db915fd1b430f"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea5d7246393edac226b270fdd4daaf4e01e44b95a22cf07e86c2c50b6e9ebaa"
    sha256 cellar: :any_skip_relocation, monterey:       "b291a27e9dae7715ceabb8470260c5ed9e139f293fccdfa16f91c49479e75ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e798dcc85762f93eff41633f5d4d10dd981ec88fd9addbb20ca9d0f21a99767a"
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
