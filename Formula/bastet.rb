class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.1.tar.gz"
  sha256 "c47a84fb17c2895ea7a85b72ea40a154a03c1114c178ea7fee341215153afcdc"

  bottle do
    sha256 "d2d89b7ece332aee114a3e28eb7026dfb385b2c1052e2bb2c9f63826c4c4c0ca" => :sierra
    sha256 "796de6f99d45c0238c57398ddfb8ade912e8395b13149a753933cd6da066577b" => :el_capitan
    sha256 "f5ef7e127187153c9599b8eef65ce6e6b31b3cf90f1bf1e90cf022e15495ae64" => :yosemite
  end

  # "friend declaration specifying a default argument must be a definition"
  patch do
    url "https://github.com/fph/bastet/commit/0323cb477dd5293b5198e4b2f47b4441d90de2d8.patch"
    sha256 "244884bed959a13e14560041f0493dc6f39727a5c8da1656b7b83e16cb8be667"
  end

  patch do
    url "https://github.com/fph/bastet/commit/968324901dae2c80bdbdb40eca1b514498380ba8.patch"
    sha256 "f68bd3aa62e4b861b869aca1125f91f90493b6c331a7850bc7b7f3a19989e1ed"
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
