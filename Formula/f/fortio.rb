class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.66.1",
      revision: "8a7d9112667e637139c788b68cb063f456d20cb4"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "914150488cfac8b636ca163e2dc903b92bd2e2acf8167c89f2edb2853bba4e4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a824f49c6bfa578c1e82624991c06e82401fbe53f4b5027283b827f0daf5621f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d73168217bd59cef63bdc96ca1769ef378806f31b9e45e522b125673992ede9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec674d9b801f86786a1c613021aa506f134e333fcc7c99790cd4bcd41747d89"
    sha256 cellar: :any_skip_relocation, ventura:        "3adadffd889f17d49b1575c660284dc26b00dfdac5fb1a97ce9cd2efae3bfd16"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2f3100e36985c9b5b633256a4ddec5182864a30a86ca322c31128382148823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "813f6ebf64aae1c90f5c18cc4a77c3412dd19979a0cf5453e1a225f6f9a74445"
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
