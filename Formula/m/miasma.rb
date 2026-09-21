class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "2163817b6489517fa3dfd27beab9eb8429c53578a603fb984b8b05ecabd97159"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "769b2759cc1fa53a8b910eceb0f65f105d04a9a618e6dc1cc63d750e8d9b0f79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5dd9d32cd45cb1d5eda730c7a21927f006af72852cc164023a9e08d3befeaf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c00dbefa1f3247f678d4ed0141c9e63373579c696b75908e23d97f73d1fc64ee"
    sha256 cellar: :any,                 arm64_linux:       "9adc1d4e3b73748169cae9c409c1630e3b8eda4ca60cee2adaff4c0761781ba1"
    sha256 cellar: :any,                 x86_64_linux:      "fde99c3c6f2894bfb8b61c5e0f058ea7b916fa88a42543aea9a21495c43e11e4"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
