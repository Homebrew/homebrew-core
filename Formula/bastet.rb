class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "e51ad7ddfc917c6c9cb1ee49df6b3ab37679df786d9b3dbedfc2e17e0d85b477"
    sha256 arm64_big_sur:  "10a5c192d9f90bb6b54d453a9d397bfd48d202a01d0725edd71c80612d23aa2f"
    sha256 monterey:       "3c198fb3b132431c891263f11e29a7966e40446030a233adcc0ee468aef0bf00"
    sha256 big_sur:        "6a997a680e2592f04456eba07c1a15ff2ec6289b7509d3d187d044b221beb64c"
    sha256 catalina:       "2e78ee311ca8b920efeff2c5a877a7e351b3c4e8edfa16f35ff8a953ef1586ad"
    sha256 x86_64_linux:   "ea80b12f8cf782502f803e24e168e394ba009a853770fdd6761d3e89149dbe91"
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
