class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 arm64_sonoma:   "e8c2e4120965628ac8fedc471b7e22c7b608de43854a855c909229040bfb846e"
    sha256 arm64_ventura:  "6942d2e417abf173cb33422b70b4b177894be32d75932beda21630e15fe6408e"
    sha256 arm64_monterey: "280c824d9cc9af9c7ca2fb8477d0951231d403a246797cb508c50adeb343b31e"
    sha256 sonoma:         "95a0f8d67fe7fcb53844256db8dee2638c954686c9c7fb853078585c10282bb6"
    sha256 ventura:        "1a02baa9c655dff5b56ba1c44ca1196204d7a008401f3a44ea3cb4d3ff81f6bd"
    sha256 monterey:       "b447e7d59ed89b4ae2e28ceb0c174a726b48803dc6c41985f262b41236f5389f"
    sha256 x86_64_linux:   "feca76b1de83458a4ffacb52e7686c2924b7e1fb9595483a00df951b60f9bfae"
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
