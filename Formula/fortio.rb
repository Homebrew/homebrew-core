class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.54.2",
      revision: "42273f0ee8694a35a90f6e192f61e0c17da9b874"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02192cc771ac13665bd26666e5d77ee7d03d874eb4ba35cd957112fe2855be64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0a0c528e5d8ec3e2dd3a3e4ef327e40b06676ee62fafa78a9103674b79b459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35e9383e31bb49429f0fe572f40813e0966389f15f9e22c7ccacf407a224da3d"
    sha256 cellar: :any_skip_relocation, ventura:        "b55f2d8e6e973fa8c8b476447284b63b41e6e718fa18e3d6c2d1bc34b496c34f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d3cc14a82770880b4f705537cf544bed9732d3ef7fab88d08e6d9998c407ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbc30ee34ca06969ad954e021abb0c3385f0f67f6d1681400da64c64bdb4f24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "505d76d9bdb697e2282a147152df5eee53bcf92b2d8f95d2ff70740d797e9259"
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
