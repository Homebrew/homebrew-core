class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 arm64_ventura:  "48a54ed15a7a18cd95c2c19c11fd231214cbe238be1d8631c96f8d6fbe8df4db"
    sha256 arm64_monterey: "f610547eed513dbbcc8d56188789f39f9c6248333ff93b5e44ffa9e2e9976706"
    sha256 arm64_big_sur:  "05f022697690ec5cc7351e5ce5993d4bcebc99ea9b0ad209e680cd7797512202"
    sha256 ventura:        "457f59e816566c6648f24d8cc3453494e4a14bc377863e19720090057b4d92bc"
    sha256 monterey:       "f726b6e48c5a626a6f3bb8e7e793c8692c6ab2a483d8a04d27e33bd49f2d5086"
    sha256 big_sur:        "4d64c918a60640b75f0c511481b7d72d574c0ea27dd03b088629e6dc1c07f88b"
    sha256 x86_64_linux:   "e7c7b021b4506c317ece8793476739e32452c4faf92e2b9d877be34e433f1ff3"
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
