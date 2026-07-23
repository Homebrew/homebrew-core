class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.75.2",
      revision: "630bfb3db6cf663b4e01524f9e9be945e44f8a20"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88a2a9f247371fc70cea040338ce869d4a4c0fd7f9a2459fdbcc03eadbc2b484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a2a9f247371fc70cea040338ce869d4a4c0fd7f9a2459fdbcc03eadbc2b484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88a2a9f247371fc70cea040338ce869d4a4c0fd7f9a2459fdbcc03eadbc2b484"
    sha256 cellar: :any_skip_relocation, sonoma:        "edaf525ab4ac7c812f03a07ddaf7bc90c072e273e355aedb4e7f6127ff721c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3783af3bd5733f3c5ee109cf8585717b7ce9c5d4c4d72a1f55bde83bf8a27046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abec5a68fa7a5299a154118f10b1042405c16b2e12c01f7a10e35319b3beebf9"
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
