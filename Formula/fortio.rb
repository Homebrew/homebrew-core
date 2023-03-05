class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.53.0",
      revision: "49f6e72a72ec061e0041f487d19e929d787c88f7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f6f065ba8b7cd147342e646ad898eff8cf9cc55beed3d8235a162eebdbad1d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fee9918b8f95c62f2975f90c400722a401a660b18cae4f8f8867ec8b7a9a078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92b31424eb0b64f965254dfd21271c2f05536e67937135e1820e4dfa16a63da9"
    sha256 cellar: :any_skip_relocation, ventura:        "830778cecbe9ea8a4339777a027c44dec11a4e486a16b9dbd695d5bbf51d4e18"
    sha256 cellar: :any_skip_relocation, monterey:       "b652238b91e64ab210969d4a8ec60a58fa575517c6485d8362b189c632deaed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a914a59cc46d4146d4a73a6c2be1e57dff2dd6984cda251c77d59b4f95818f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336b4589d9492ff82756679af69a621cede17573bd30cae28912fc3d1e8aa3bd"
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
