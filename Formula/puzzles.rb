class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20180426.a1663d6.tar.gz"
  version "20180426"
  sha256 "5e3cc692d0300ee70430eed73b6c4ae2fda8e2e1f8829255f295eaeec16432d6"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb723ac7e96c498cd3ce60a4db048f4734afae659056fd50999a9243410afca2" => :high_sierra
    sha256 "9f1b4346940f6e44dfdbd7eb45c386c7a229e10638571bb07e4b6e205f60d441" => :sierra
    sha256 "e0420bceeef67f011a6d8bd60d6570163288a6f2106d5f193937e027df18b1cb" => :el_capitan
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
