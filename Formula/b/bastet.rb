class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 10

  bottle do
    sha256 arm64_sequoia: "3609a905ba94c6dfa333b703b2a98a7d2d104f98b9ea01e4ee8e5d50f7c1be93"
    sha256 arm64_sonoma:  "3b694178acf005d63ff6005cc31b4432b2c085e6f4442787ec71d6ae684480f7"
    sha256 arm64_ventura: "396f9c63d674290dc9b51e9a883f2de4d1beadc18f88ca517b9c4766e285e8a6"
    sha256 sonoma:        "77d12f1eb8fa1ba72bb5c5c352247b059268110baa8c67cea54097b392b0e7f9"
    sha256 ventura:       "c81ce5e9ebdb37bd5b779670c0ec6b79096b9be3f86116c5a52e6301ce0902aa"
    sha256 x86_64_linux:  "d39605f160ac522349d9b0e7d0af9320cddd62793a2fa656caad94eb78c70bb2"
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
