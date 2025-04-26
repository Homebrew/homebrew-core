class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.69.4",
      revision: "54189cc772636e28108a43aab57f8bd528eef99b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40fc85eb1b30e99fa04deef5776c97b7f646ecfb119bec919f8b19352cc170a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42350013060e00ba270200588f422437fbb36fced0ff39c3a86372733b016149"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd42f0c87b70958c217818df5af71b91e67e29febfc53f68d271841041683586"
    sha256 cellar: :any_skip_relocation, sonoma:        "5622d2c02e96f447cf644c3e8be5d3bc01464828dd19513fa59e69ef946ea142"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf2502ee719b269412595848a18b5f08a0c608b515ff22550c71d691b00bc3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d175d565c6e73b92f303a4168e4f74a7eeaba4a9bf90c38eee9f0695867dcdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7a91a4fd2a4f71179b3896122f56bdbbba6962aaba526f1d269383683e13d2"
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
