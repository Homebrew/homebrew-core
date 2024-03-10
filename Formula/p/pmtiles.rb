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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9138703b839b7bedf244823c5ebde00d68d1c9de5387d0f708af0dcad16ad05b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2397ffabfdb96580cc900db07d6e0afe626980a55cc61e436c554db23c12091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b850926f3982ec7eb435d2188a3b83016e81657e2a05eaaf5dfec8db52c98eb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1756dc37fa2f7567977c7839adc0efa3c33ceaa56555eb0a43e2b61ad6463ce"
    sha256 cellar: :any_skip_relocation, ventura:        "365b8d0b6b9a429a095b9765221946164a2682a59cd8a66e2ce93a4005fc611a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b58f8629e5b5627fd95b54ae5545a1e2a4d168be4032776c27ec7acc74bea84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11815e2d209a3506fb9795ea4dbbf728e4395b01a7fb147d7f8418f5b1684fd1"
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
