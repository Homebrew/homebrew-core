class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.18.0",
      revision: "c0e5fce3ea4bbe623481c15fcd8dc81beb553aec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365e1cb6e0574605fced79d7b9d88de31f4c5230be61eb374ffa94c19b00c7ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4e35af269e0524dbf1ff72990b1ac82ad2e812db2961777ccf69a385629c746"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0e87aa00c51b400824707d5d6385e02365d845c6d49c0059bb078b8ef5653d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c422cd10f9ac3e874c670cfd14baa5a5fffa26b4e3d6683d25094db8aa0a9fd"
    sha256 cellar: :any_skip_relocation, catalina:       "0eab0492d4ead9b787c64603cbb3fe3bb7b4e050d2d12eeeb749cede38bef74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62bcb1faf27acbf4ce5432a78743e57aa836a318618254729e0bd35989b96903"
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
