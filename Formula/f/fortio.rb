class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.72.0",
      revision: "fe0ca2c8aeff685b7aa1aa77fc197a3e9273e725"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aefd591b9054221e6049a3c2d4e4227d77d91c00fd1f4c0e582e8fe6152a9ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aefd591b9054221e6049a3c2d4e4227d77d91c00fd1f4c0e582e8fe6152a9ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aefd591b9054221e6049a3c2d4e4227d77d91c00fd1f4c0e582e8fe6152a9ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aefd591b9054221e6049a3c2d4e4227d77d91c00fd1f4c0e582e8fe6152a9ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e92c2176bb28c930b2fa350b81281b984b478db4522481f4fbfbfab89c0488b8"
    sha256 cellar: :any_skip_relocation, ventura:       "e92c2176bb28c930b2fa350b81281b984b478db4522481f4fbfbfab89c0488b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99d173976539f58dac151146bdbe9b82193785a76201313f129338f9bcc82c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd61067707c091a783c7200684f50f9667640b1f0147cf9b8895f70708fe8f5"
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
