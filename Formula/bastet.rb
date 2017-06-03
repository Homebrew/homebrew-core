class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"

  bottle do
    sha256 "d2d89b7ece332aee114a3e28eb7026dfb385b2c1052e2bb2c9f63826c4c4c0ca" => :sierra
    sha256 "796de6f99d45c0238c57398ddfb8ade912e8395b13149a753933cd6da066577b" => :el_capitan
    sha256 "f5ef7e127187153c9599b8eef65ce6e6b31b3cf90f1bf1e90cf022e15495ae64" => :yosemite
  end

  depends_on "boost"

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end
end
