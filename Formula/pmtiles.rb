class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "7f04d79625cce23273b4fd7a9657252914bc8ee76e918c1f3f78e7ae1fdbbaca"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f31787482d1690aaa24a49e6af4b00aa1b2889d2fbb4c4d27924877e3af013fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31787482d1690aaa24a49e6af4b00aa1b2889d2fbb4c4d27924877e3af013fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f31787482d1690aaa24a49e6af4b00aa1b2889d2fbb4c4d27924877e3af013fd"
    sha256 cellar: :any_skip_relocation, ventura:        "abc97175968e45d7db33c7e71266d95492bd0ea6521ed9fe32c810dafa12f1cb"
    sha256 cellar: :any_skip_relocation, monterey:       "abc97175968e45d7db33c7e71266d95492bd0ea6521ed9fe32c810dafa12f1cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "abc97175968e45d7db33c7e71266d95492bd0ea6521ed9fe32c810dafa12f1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51590b8d2b9f77d180a0ffb75181e4251f78ab32fb3f641b5691f694f031b40"
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
