class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.31.2.tar.gz"
  sha256 "022386795fae441dd35927e4061daaed8cda7e21ba0a2e2253c8fd0d85bc482f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97a0329f0e88fbbac341495b5615b1d4086dc1401f60d68c5ac1a4971de70e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ff0e7d2200f4cfa2a2c138130bf8d1d3d0199ae86d6912c6cd2a8062afdd9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6dba8b2647a829ceb427b1281384750b62ca25653806e1748c2a9fd811c5bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "19929d009b2743cbf54bef3ad1282320de25a735529b6416512792f933439ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "221f0bdaec0c85c400537c9241747fb3a8521fb37b5dd1b2df067a5571bebdea"
    sha256 cellar: :any,                 x86_64_linux:  "2725fda54374c65baa157d8244076679fccf27a1d223a1ef2ffddba2d9b75c45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    pid = spawn bin/"pmtiles", "serve", ".", "--port", port.to_s
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
