class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.1.tar.gz"
  sha256 "c47a84fb17c2895ea7a85b72ea40a154a03c1114c178ea7fee341215153afcdc"

  bottle do
    cellar :any
    revision 1
    sha256 "582b03b73c28ef526dcf0c5cb972245f21c10f0d93122ae216afc9667c4c8e83" => :el_capitan
    sha256 "f831035af03c3a8541d614dedf5548d0c360ebf5aff9b7eec4a47b6c28a10b45" => :yosemite
    sha256 "a2213aee8e63aa7e2fc3b263282b93de7394d034ae36287e53e306b884306e18" => :mavericks
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
