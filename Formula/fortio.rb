class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.30.0",
      revision: "15150b657787587ddfe972935a0633da2251ae5a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb728ef422a576f53a92cade23faa88f5040d1c73fbb355aacb180fab720bee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b699bb85a052898186932217a5a4551cf50414ea9232ebd32e085055a08087"
    sha256 cellar: :any_skip_relocation, monterey:       "d045fa44263402f2a89f462fc1ab27126d8b9253b4d3c167dba72dade92b67b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff0d1f1f12214da8fc64363a914c0b93278d5291889b39c6fffd400c8e935c1"
    sha256 cellar: :any_skip_relocation, catalina:       "0255f89757ad491878e032413368c498a29cc0a0457f6ec57f2d30899a549866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10960de58ec4395b3dfc98b7b2650e4d59913ed417dc00ce9e311b5e57bd9179"
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
