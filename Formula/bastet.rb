class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"

  bottle do
    sha256 "debdb55e854497dec7fcf2b8324513ae435ba52df6f963608ec97519368b1587" => :sierra
    sha256 "6480a6a2fcb155c29db0baf135a9cb8d31ef7540866a2f9bb9bfc6d2b50a7690" => :el_capitan
    sha256 "dab9a1b75d5da4c467b37dc49b76a0bbe5c9202eaeb321d60a341ae7cd256098" => :yosemite
  end

  depends_on "boost"

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
end
