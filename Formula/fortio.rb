class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.21.0",
      revision: "4b1eec7b82bc0a626af9c253a270673fa3721751"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6f9805dbb084f278e3762a280d1f114ce41b083a343cb48a94544b4cfb8197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a17004b44f4413f146fc13c871bcb6b37001289cb97e493f742a2bc2e6c0381"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5fc786958b6fa2059c94a018b265dd0eb26ac9cd475e72e88e3ed2be7fdc39"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c473908185031cbe4e308223a4413dc9bdd2f740713d9d79081e8eb6ceea50"
    sha256 cellar: :any_skip_relocation, catalina:       "2d7d64148bb65a0b2d7dab2d7ae50e7b8dd4c819860db4479926b3a13b7d8b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7031a304502832eb784729c62180377035112ef34f7ffd319497e66dae174b3"
  end

  depends_on "go" => :build

  def install
    system "make", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio"
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
