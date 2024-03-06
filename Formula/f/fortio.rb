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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a539bfdc2a2bfc847fa9f28bc5e2d1833264dc734bd3f47de942adc0ec203c8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "056a80679cd2e394088dbb50108cac21ee2a689eb75e3cb3545c1dbde6c0b69d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46935b45484f4d427a1a36fae15d7751e6905e6c4c38371211aa27d30b244d2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "389496fd47e9c89d1c9d57f1b5dd90d2bcaa505f1ec31bb0d12a566cf9cc37a1"
    sha256 cellar: :any_skip_relocation, ventura:        "9d7c5bd3fe5caa49485d9de54d8d7aa2bf617c28da6e29d838e8863fb8d5d47c"
    sha256 cellar: :any_skip_relocation, monterey:       "03cfd84a7dabba6471f5888b4f5d43e9a5c187db7427706ef35dabe2735629c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b23cf8b359cb0b35be109fd7625201f911e477d33e55f4ad313b51712c426ba"
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
