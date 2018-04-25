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
    sha256 "d283d7e9cc4ec3bef4cafb41d4739cc301bdaf31d62af81494f84f9a04319db4" => :high_sierra
    sha256 "57b04776dc4696ac93b9230c4df569f3aecd36b238a05e73dcde3493659dc847" => :sierra
    sha256 "57b04776dc4696ac93b9230c4df569f3aecd36b238a05e73dcde3493659dc847" => :el_capitan
    sha256 "e01a6fc502cf54a2fc1d1c05a8d1e04b3762defb50aadd9d67e4049435649676" => :yosemite
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
