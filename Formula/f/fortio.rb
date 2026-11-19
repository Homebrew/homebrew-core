class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.77.0",
      revision: "d940ff1a1ade9926677f96827174c5593bdae6d6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf4bc186fae5441dbe9ae7b4543074704b180aea7117ec3e14a4caf4dfb953a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "619610e7b5088f835c3a8e117a2ea9570926bdf0126afb30eb2c91e18f194190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "155bf1b11ee8baff2d7ae81360442e5e66b2885e3d1779e3beb3203def98c609"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7f213156d55113edbb98cf1da48283379fb8a674a77eeb0e1897ad8b0b5f7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ea2108667382a08bf452102674635065a6f8f691008f6d5a6d3731623c0b70d5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "-j1", "MODE=build", "official-build-clean", "official-build-version",
      "OFFICIAL_BIN=#{bin}/fortio", "BUILD_DIR=./tmp/fortio_build"
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
