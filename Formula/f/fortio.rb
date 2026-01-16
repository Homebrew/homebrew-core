class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.73.1",
      revision: "e7d1fea2a94108269baef277dff2c23f31035a60"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a229bee0e9ef7d5a05c914c740f58da0778272b1a63eda7f042a45732ca1b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a229bee0e9ef7d5a05c914c740f58da0778272b1a63eda7f042a45732ca1b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a229bee0e9ef7d5a05c914c740f58da0778272b1a63eda7f042a45732ca1b58"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7a000702fd1edf8df74269457fe993b80475d091adc5de56665ff45ac348c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a9a96ba0839771e054e1b9f396cf9bdf088919d27ceac427cf655a76d4ddc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5e5ebc9459fb5e810039e8b2664875caf488b10ca0bcdd9c7c167ff3379952"
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
