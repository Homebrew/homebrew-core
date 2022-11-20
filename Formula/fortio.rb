class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.38.4",
      revision: "860b2f915597a1c48e6d74e6140ff94998093593"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10cb3a098f97be960268374b02feed4ad48c9e82c40df8f3b25e49e383687cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f15a22ea9a0531589c9ba22a909f8c12268c84bc8cce9544d4ad2ce069ea8067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f68a495efea4b3aa1b4e2c5c704a2879281d72ab907090072c798dcf9697bad"
    sha256 cellar: :any_skip_relocation, ventura:        "39e4b923fe26cac551b148cb33622e44284b3efecb6db75a723a66bb9fc90637"
    sha256 cellar: :any_skip_relocation, monterey:       "55352349847ed400b78469a1ce020af5ad4ef64bccc77d13b441f98685fe29d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "45991fb27f2d00da588b7d1ea099d832b622200c215eeaeb161d802d8d0f74e1"
    sha256 cellar: :any_skip_relocation, catalina:       "a416ecc0f7c77c7d2c8b932143dc3da3b20aaab3461318f99daa546efbd8272f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f6e8129df2205c708052d75d86b23f36837b38231f3e3dd8110190a69bec25"
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
