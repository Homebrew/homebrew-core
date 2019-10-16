class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"

  bottle do
    rebuild 1
    sha256 "0dfeabb0071431e426ac18b366ff5d065067075e7d3f4572e55a281e6702e215" => :catalina
    sha256 "d1315f05616c060c8b5e83a9ae494f2ffecd2f78d53ef554192bb0e12ef451ef" => :mojave
    sha256 "188658452934d4ef5d48d6837fb0c6bf3e3875488e0c1da8dcf62ca37c1ee998" => :high_sierra
    sha256 "8133c13d1b98d96eacf5d420d30378fbfcd9cbe898b0f13b188112618f4338f5" => :sierra
    sha256 "e3745b716c09ce7f3834f4fc30163fa132f93feeec4c301dc9d46b0bc9ca564f" => :el_capitan
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
