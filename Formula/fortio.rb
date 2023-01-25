class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.40.0",
      revision: "43a882efd38f26ec6d70685090c6fdc78b1821de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8b3e343ee2e9fdac9cb3f4a1a6e3088ea12e802b5430cc1ee3be0759343ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39071b4337f4c7252cc94c6767e7c68d94213e0dc9f8353f382e52f82b369fa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53ad48af734b859a028e82de13d230cde90c541040f94df3e2190853e22e4fee"
    sha256 cellar: :any_skip_relocation, ventura:        "e306342950789816e497e2f12b4222ccab45ac34076378b629ba93921c7bf9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "afa06b7e1573fe6eb177d8dfea974d5395bd13ce8c96b52c983fd06568966d7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06e3b63d4a775aaaa8ee38e41fe37c384679309c7471d880d7c42b9a67323f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1b6303c37e252dbc75952bb7ec59674bb953da72e0413e6818b80ee6faa6ec"
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
