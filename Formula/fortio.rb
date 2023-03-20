class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.53.1",
      revision: "fecd9f32c789b1f4e576bef76ea01623ce82e644"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "247b19b21176c82990e9d691d40fd588c3fb0bc6cebcae897ace66104711a3ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb7fb8cf2898c5b12d59dc9080f0d7195c00ce0c7d590a3726b87b8bac54166d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5661bb9ca38d7c2e206c867d2fab2e9c1388bc7e3b6db658601d931b9394ca81"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6b0d5cdd93268ba4ac428b20d0780ff5e5a7a6f61667ae6a6b312f68b81a35"
    sha256 cellar: :any_skip_relocation, monterey:       "10fb3b8b464dd88e4bd276cd18f75db858012e6cf6e29fb9490b7123750249a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "387610fcc11eb0afb577e4acaec4d96730cecc68e024006811290b18f46b8410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b5a0ff58b30a89360b9107dacdcdcd0da8e413d62dcadb42d3ac05188b6d13"
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
