class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 arm64_sonoma:   "e3b58e16c8b3462ad7f3fe67a4f10810718e81dc6498d64e685bac37375372c9"
    sha256 arm64_ventura:  "d4e089e38a41f53446c2d29e787d4184675d8c788d40800d91293accfd21ef3e"
    sha256 arm64_monterey: "2c0109b7b103eef26c4356f2eea2ed812a26f50a3a2410e454121191af6d9edc"
    sha256 sonoma:         "3215a3404ad42670c0c82ca89ee2dcaaf2c5fc599b7c332ef6f122dca8338b46"
    sha256 ventura:        "7fe250b52908b3d92a34b8c96ff974e0fe9f1119e2d6690209527c84625c8b80"
    sha256 monterey:       "f40c7e6f4d1a6b6676562894e79563be063a3ee2ca2f601026b3e51406402b8c"
    sha256 x86_64_linux:   "9506da17d1ef06e9f5378b7996837ecf3c2e3e693424f924fc09a33a3a6c60ff"
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

    ENV.append "CXXFLAGS", "-std=c++14"

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
