class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.73.2",
      revision: "13c81dc5609288574a09c01e48addbced4197c6e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51974a735fa884cc4f863f0c78621a3400c1e86f4da8cb8108cd5eeec71da925"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51974a735fa884cc4f863f0c78621a3400c1e86f4da8cb8108cd5eeec71da925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51974a735fa884cc4f863f0c78621a3400c1e86f4da8cb8108cd5eeec71da925"
    sha256 cellar: :any_skip_relocation, sonoma:        "86513246bb68069b5e380b46b867a6137b4ddcc041c55afa077e1b51e5f06dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0799649558ec61d3b02eb5b65990d0ea0b69812ee05a113a4e4819b9221334e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d248fdbbdb0c260891bcc47b106a6e2bb5267a605a948aab5c5ebc7f57634208"
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
