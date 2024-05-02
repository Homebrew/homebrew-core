class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.7",
      revision: "4383a362899cc03b885944d326c204bdf857a186"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "618217e84dbf0f19266de2c1557ab492e3b9ea3558824bd1d4c4296c1b5eeaed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467edb8495fa381f702b4a202407a4327453c2381f8628f48d76c73a0122a34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d27c1351c64275576416d0157c73981a2674b7402d82ce0730a18e98dcdc4c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "adf1324375fe113300efe280c93b42450534849e55530477b147f338ac26aa34"
    sha256 cellar: :any_skip_relocation, ventura:        "0b1c4b2da7eefab15d8bc67cb6f567acd967f952c3a92585704a328765c1830d"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc87a2be1b189a4c05e2617b3cf4b73c40cb26ff78be28dfe467589ba895140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2ac7fa3bdf192e2fbe9fd8c8ab7900d5e34a39a27ef14aa4e895ef7a52c848"
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
