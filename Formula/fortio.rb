class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.55.2",
      revision: "c39b74f7f44b365dab0e7c753ab21691bb7c1861"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e05b5f5bbe993b8e68081149dde5311bb9eec4c8332dbaf50609a90f5e12d5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c640f0e5eae0e5d793074ea8219c0a0e85b2ca01fa928c8653f92c691fe29f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60c730a39ae71c1dd462254e8f7a3f1b9b5d7814a65a4209c8f30457afb7f4d3"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c02fee14ae3f516d4e1b28f274d6310a8bcfa086277e168b9e6ff83cb102b6"
    sha256 cellar: :any_skip_relocation, monterey:       "c64022caa434967bf26da2a8efa5698ca21408396c812631cea2a4c64bdee60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f60b65a5cfd3a53817968ff6a6dd416e3f038a7dfafdbf4ff88eb45244dad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89e5a0fe4757948aedab268cf520b12eafb08c25a377e31cb42bb47b373e915"
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
