class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "9847fe14d15e54e4e38438ed8282abbc922de3a3ccc7ad3648b6f1be61707a44"
    sha256 arm64_big_sur:  "048b7752909e1c445b8367ee87002df7511d5d1520fa0f2c39103f60a7c7c3d8"
    sha256 monterey:       "4efdae4d19ba49760a781bc930d97b7ad6559c8a8ea987cf628fc48ea6dcd625"
    sha256 big_sur:        "fe79a047ab3449c63ca5890adbfc2c9b703bf6069ebe851cc4af1db8546b3f2b"
    sha256 catalina:       "0dfeabb0071431e426ac18b366ff5d065067075e7d3f4572e55a281e6702e215"
    sha256 mojave:         "d1315f05616c060c8b5e83a9ae494f2ffecd2f78d53ef554192bb0e12ef451ef"
    sha256 high_sierra:    "188658452934d4ef5d48d6837fb0c6bf3e3875488e0c1da8dcf62ca37c1ee998"
    sha256 sierra:         "8133c13d1b98d96eacf5d420d30378fbfcd9cbe898b0f13b188112618f4338f5"
    sha256 el_capitan:     "e3745b716c09ce7f3834f4fc30163fa132f93feeec4c301dc9d46b0bc9ca564f"
    sha256 x86_64_linux:   "02918b45d68fad9e1ee1e3e4f520107398e2f7df1501dce5f3a7e0052ebde359"
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
