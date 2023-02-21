class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.51.0",
      revision: "2bd5ef4e0034f3789706f50f15dbf0e057615066"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0817fc8620755b4000b99463c355aa7a85f65e3280d85a924981d7421d679b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47a05249e49e9b23bbae7e91df2ce69614a95233492bfccda1f5ce615b69904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "312cd3bac9b4e40c836f9e1ec57c6bb3b50207bf14f9f85f4ca2d47c0e44636e"
    sha256 cellar: :any_skip_relocation, ventura:        "d170681c4c93964c8529e1f08df45a72b88c59c5c9b524ea45ae5eb70bae4252"
    sha256 cellar: :any_skip_relocation, monterey:       "dc25a26d733bcf0fefc7558abc5c590a4f4fb23c88b64e5b8b788a0bf57618e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2957485d989e7b7ea1b09765f1a24600a93c287c4ac754005523165ba0da9a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ed2565b36fa6239b771b8752ff83635cc55a60bcf34e2f0c3740b66f7a7a96"
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
