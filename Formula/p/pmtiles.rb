class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "d59eeafa8ccfeb5fcfc1787ac754c3eef9812eb6903c8df364078522eb8ff098"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb9d7e3289d05e778ca0f52c8e4760637e64ed8837536b54a4bc61e429cbbf33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f5d8b7a5a20202d6d8261f3db8f9d3b93e6d4b1b10b700f2c672ff9586eb84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8abfb266532b40957407a22da0981520d39e144389e4ff5a642dcd74ead464a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e15f08cff2cee58342811acf0a37c31ab055514558aaab90f60a610ab9f065d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e616c0d8d4ac3f63bdafd38f09896a6f1ddbd1f239642e88c671c4d5cf2ea73"
    sha256 cellar: :any_skip_relocation, monterey:       "3755a77f8c6c6dec8bce9a06807d2b647d05fceab24c2c326e2c072a426475a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0743dc7e4dd02a003b3d205fe09e4a289b303bb2f88ab19b03679e3c7ca52df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
