class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 arm64_ventura:  "ab8917177ce7dbe0adf2ce68b2b74d931d62ac124b702a029475717e058dd5ee"
    sha256 arm64_monterey: "af3f3df41a07583a6e6737c475b374a65eddb79c82d62e80f4350a0b93d206c5"
    sha256 arm64_big_sur:  "62eb01fe9d32979f3f21a1e477a3808a6d0aaef5939342e2a02970b0367ffbfd"
    sha256 ventura:        "cab6773e9e5cbfce880975e6401d150d06c541064333a5aa698e25b5c0335d78"
    sha256 monterey:       "fda8ed1bd078f83d4027af1852af55c1314c5b3b7eeb249a141eade4f24f2529"
    sha256 big_sur:        "9de7d39f5e3cd635dd8f2ac0ab8e8e95967fe25f1b00c95c5411927ed760ac0e"
    sha256 x86_64_linux:   "758f1f3cca344de8ce227fcd021a36ac6c34a9460703e1d9d3f14a49d974b4e8"
  end

  depends_on "boost"
  uses_from_macos "ncurses"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
  end

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end

  test do
    pid = fork do
      exec bin/"bastet"
    end
    sleep 3

    assert_predicate bin/"bastet", :exist?
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
