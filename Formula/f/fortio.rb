class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.10",
      revision: "b5dce2383d64757d024fa74196483aa6f8ede206"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d94fb81a577b04091aedd4aba67c9fbbaaeb6ee43fd6a9057fc236b3719d91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae30f09767eae495cc3c4ffc7394ff70ebf801970393216c81f18fa53a567e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc67d586a10edf21bbdcf6287a4de219570388ef3b6900a993fdc44bc33f625"
    sha256 cellar: :any_skip_relocation, sonoma:         "003385f355ebedad8812191856e00be3ffee69840ce46a27eee509bf621c3dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "e8431c22b3b091b72a8bca9ad3c53016c67c64a01345a1d5472a1fb11b05cfbb"
    sha256 cellar: :any_skip_relocation, monterey:       "fffba2a1c0cfa96db18ef7aa10de8528ad4441953c9f19dbeef3654267660a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3827cc25825846e4c73843f0eb9ef38f2b9cf2679b3de7950f33e9332b819056"
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
