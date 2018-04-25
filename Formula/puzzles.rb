class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20180425.b3da238.tar.gz"
  version "20180425"
  sha256 "bdf708b1342bab704a358ed8b5337dca24e59bfdaa2242a0a65703eb71d4659c"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a38c3178f3b0920ab0f00398e1e1e2e22fb3132cfe9e8b2d614824ff5cde92d" => :high_sierra
    sha256 "40e877f288eff113e20c87e0884e2ab85522784b5b3a279c2763cc131a009136" => :sierra
    sha256 "b22c137a442ded8b44107e23d58aaf06509959c7c73adffce5cd75a15ce396a3" => :el_capitan
  end

  depends_on "halibut"

  def install
    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/puzzles", :executable?
  end
end
