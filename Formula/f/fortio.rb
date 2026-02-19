class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.74.0",
      revision: "5e8726d193ae6cdda257320411aa1c4eb890db45"
  license "Apache-2.0"
  head "https://github.com/fortio/fortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02ac622031a875c66b580bace7536a329d17cdd43cb471410cb5d7d833e4dc2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02ac622031a875c66b580bace7536a329d17cdd43cb471410cb5d7d833e4dc2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02ac622031a875c66b580bace7536a329d17cdd43cb471410cb5d7d833e4dc2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2bf13857791fc4aab8165f9859e6c394c19e01c0171311c723871e7e6016571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d39b0995271882402fbbce912c34f629fef2a374f14cc58a1276d1310cab40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d0210fb98bab882a6f2de83edb766d368fbfdc7ff39c0515d617ab35216a722"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    pid = spawn bin/"fortio", "server", "-http-port", port.to_s
    begin
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
