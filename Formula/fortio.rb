class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.34.0",
      revision: "c0edff4afafa4013592e4a32cb9e661efa85bf48"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43fef0f297b1fee6c56af2718cd9b6fd29177648c90ccd6aaf71e97ba2108e67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d8706538c139e4530f4964bf10d45760d6823f11ea18062dac57fb6c94505c"
    sha256 cellar: :any_skip_relocation, monterey:       "53c0559f762a71a23bfe2d52ce520ecba5675bdd288d28e0544d8d7841022d74"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbcde7f07c85f7dd011801dafb0d069df2d5b80b1d83012837132dd0df16d294"
    sha256 cellar: :any_skip_relocation, catalina:       "a1b75cd5ad72475670b2045882e54987a60683b341c1ba82182568f0b2689023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4828f905db60230310244e1f5bd629c4429cf094693f82186f513526862f280"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

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
