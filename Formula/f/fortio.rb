class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.76.1",
      revision: "32a39ecf9482289d571aefc6b4622a0a868d21d5"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6517de3aed56883766e76f54a304384b9f11684602b6387c160acfd1b2774106"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42f252108aa323de87c3e145bee3baa5e3d6da36b98b1876fe6cfa0bb1e669ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2cc25f84d43c472b44ae42aebae928a35bbba20bfc71b7998eb3311461aaa696"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69434bd8dbea43bbdf85f964d6038b0d3201f5dc1f8bcb9fd38a5da05b311cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a1c5e8298adb36c6e8574406008e8df5bb1f1493d3d3081a8119194e430d8525"
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
