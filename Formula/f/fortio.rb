class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.75.0",
      revision: "f935cb6d2d87d954f18ba692144e8f731e891cf8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac3178279e4fd5fa406bc4382fde16b136d1880410c07ab002d473a7ee9c6047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3178279e4fd5fa406bc4382fde16b136d1880410c07ab002d473a7ee9c6047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac3178279e4fd5fa406bc4382fde16b136d1880410c07ab002d473a7ee9c6047"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c8c2d24180bff857df056d94d1f7c24438ccad3f6c127e2fa3183ebc6520e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a33f9749fec2e3d3e2f25886fcbe92ed60e8e3010c46a396861baa9db1213c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c971f274734f9c8e78809277b2bc28564083771f555b6f2ef66424daf368131"
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
