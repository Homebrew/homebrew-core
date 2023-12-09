class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.0",
      revision: "6b492e20fffc070f3ab624cf960793a01651cd19"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc4539bb78c114406e00512192ab903ba234577afda79e09e44458db0caacc98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e5215669829f163752b6b1d0243c7ebe005732454e9f536eb68a027f40f7aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1571d0678a73123bfaa258f1e28c1c0a7c5adb2f99a5c313dd0be43980b1a0f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "afe7443d2d32edbb6f1ce2f881d9a1b4908be10e0a1c63dc2b899958e537df8c"
    sha256 cellar: :any_skip_relocation, ventura:        "1f89208226b342a6f46c3d738843495d8d4e3ff53f7710e94b69368df522c206"
    sha256 cellar: :any_skip_relocation, monterey:       "909da5f724e5f1a602d3cae20d735f6954cef259e1fa0573248d4d4a66808b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe15bf97c68812d4bd9b5bfa80b0cd6c559dc0ac5206f5821bc4bba8ddfcab8f"
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
