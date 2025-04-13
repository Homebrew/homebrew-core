class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.69.1",
      revision: "6d7bf7490ec2e01ff12cfe43c2e6c1f8350f750c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc11bbd31746b9a1cb7a55977337ffe33c2459150e3aec7f02ad0e7f2d955464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08204c9b41df1ad1ae97b91cbf0e55f45a5374e7284f746584133725922c0cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e47014a15bb39c63e73fd0dcb6a6b8084f2a11176e7e3c1cac0e85503a03bb4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4346b536efe1003f3f4f6f39c5e5267733e44c47bd162075f82b9b45b3b03f"
    sha256 cellar: :any_skip_relocation, ventura:       "44d7e8605402b11cddf2002b84cd35056985b8117c252bede62eafd00be96b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd9c6c06690f2e32f6296341c67b6709e4418f334f4186fa97f11dae6fbcbd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fa129b794600ad1d12e6be7218c79f9bb6b1868b2ff99791fbea3f8d0c3125"
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
