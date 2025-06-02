class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.69.5",
      revision: "929fca73f8f87c0b67a5b633b0d381738fc320fb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b500c7a7a496dc226094ca320d8a99a04bc3aa273e8af7e37fdff6ff44933197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64340701c0c1c7cc539f0e3b4da18500262ea1a98f52ad4faf0cc9998c94c530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d262fcfa2522516246389f6ded4bed17cf7337a43f8901d4969540b230a81cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "931406624524c3894d56ef06785f8fce2cda073bb44cba7b904421b93af3a8be"
    sha256 cellar: :any_skip_relocation, ventura:       "75e1e9deaaf1cce6d415e666d8e5411203a6f5b6cdcee79c699bf03bab931439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af177536582d310844f2f4b0e92292d1924bd7d66c945b340bead18bbd0dd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c492f6c3a37632f66ed4b86911df00e83b88409feaf480a8cd4978273e1bd7b"
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
