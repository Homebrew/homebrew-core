class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b97095cccba9d13d79f52e216ed25d598f2fc203e050908ca19e06ff8060f2d7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f096280ee6ad1a1a280545af8ecc799189bdd09f06ca6bcaa3aa1116c88155c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c78b1e29063585f9806f8ab273372f5fa00d7f8ec8dceaf7c5447d5a80b3d682"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae01c642e001c4d7779d16849711e8640f45ac3ee054f2cd11271414a636c6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "520202c6e443075e46486ff83593fea76e97c2f8ca1a4b8d42e9762537174074"
    sha256 cellar: :any_skip_relocation, monterey:       "ae732f299f5e9775085c541902d31e0a4a2c74ed1bc60921260e0c751311f40a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cefff2eb21e3857261122fb5fe3dcf246ad5ff4e2d007b276dc233a9abf675b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb1a920ed05ef7bba0f281140d07124f4ddcb41cbd4070373688829fb24a0ad"
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
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end
