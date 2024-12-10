class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 10

  bottle do
    sha256 arm64_sequoia:  "6573987f9ba4434ee5ed34901157c7a6f7f6cfd52d00e67b5955733c34a4b0e0"
    sha256 arm64_sonoma:   "99510b92a64c32f9abda92c23c45f7700950c4b656c90c4f45dcffa7b21c0a69"
    sha256 arm64_ventura:  "b95a617b157fac8e977ed972c638ff36b388dec9c1ff2d2ae03a75eac78971bf"
    sha256 arm64_monterey: "beaa5643a5e1898e3c4a750b08b1ab48a950ccbaaed03ab258c30660cb905444"
    sha256 sonoma:         "733d2f4f060507d9f93c70ebf3541c1342f7ad26b3e1ff04748a0e334cd042f4"
    sha256 ventura:        "f8aeb7ace53406c2c65f107c75cd47da12c1d3b4c55188c718778465dfb07c77"
    sha256 monterey:       "bf805f500f2200dcc8ed4fd9af36226f24919809f085ceec2fd583b4839888f4"
    sha256 x86_64_linux:   "0aaec6fe765c9c4141acb901205cfb2f6b80a22d3101cfec1b54852860861923"
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

    ENV.append "CXX", "-std=c++14"

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
