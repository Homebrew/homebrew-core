class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.75.1",
      revision: "a794ffd9e54d06d63392f072fba7bbef56faa16d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f35ffdc98d15b367cb9ee11bfcf688530e9177793ed20ff926d5855bd848d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f35ffdc98d15b367cb9ee11bfcf688530e9177793ed20ff926d5855bd848d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f35ffdc98d15b367cb9ee11bfcf688530e9177793ed20ff926d5855bd848d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "73ca457e0e0fc560f788bb8efd2a05e3459b527b1ac1d42232c578bcde271b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07a904d630d84a8f524a7172b449d0c8894c60b58e435799f4ba9791ee7a8fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953f67ca814001d047c648cab14163b609f5aaf5e4fb0e53b49f6c5aeba354f8"
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
