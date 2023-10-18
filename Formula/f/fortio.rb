class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.60.3",
      revision: "197424c51b1d811b458415d55141f92c5f3464ef"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "812b7d50e9a3da45c9e1d618aa47b7c18f15b975a7e266cb514202a3f2b00b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9745959abfff5aa41620a6858d3e84f0564a41eecd3d0522ff77b9a0a5646ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560cbef7184424da3fceda4ef41dff289c36103a67fe74849365b015a3e91baf"
    sha256 cellar: :any_skip_relocation, sonoma:         "64fe2669fde20f6586fa442d287e116823c6cf990544da92f88967c9317bcaab"
    sha256 cellar: :any_skip_relocation, ventura:        "a701d35e658f3bd5e5fac8de2022ce681b6a27f385f8bf8ae5cedab4748f7a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "9044fdf4a5b6ce12ee32b4f4c07fd2ce0963842418a04d4a0d4a3608a1a61589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82862e713f91e418756da4cf29cd6df8278068f96e4b159ed544192aa8d2b208"
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
