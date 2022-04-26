class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.28.0",
      revision: "57e9d8f01c342a4c1b5d96f883f81128b04d991a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a790d05c133d4aec3e97714e08549922b7995946e1bbe6dcb1e71fd939dbcd58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07b1695b343c5b33ed51d484ed0681282b94872956a222c482de4ce4212abb5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe190f51022b2a102083e84979432acc3f61d61945f6ef365c5b79493b0e318"
    sha256 cellar: :any_skip_relocation, big_sur:        "f728bb29900121783f33af3d192018aac443f42f536ba007e72b86a763b15d88"
    sha256 cellar: :any_skip_relocation, catalina:       "d93659fe58203decb037b4fa03088f77ab9ea5580c62f78ae38227709f9b58ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f9dfa155fca32c5632962c2d6e714726331b6d92901133b8cffb487f8a4e40"
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
