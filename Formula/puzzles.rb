class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20180429.31384ca.tar.gz"
  version "20180429"
  sha256 "3439c62d6803a5f6f42d3eaea110afd187e750e453f845d1e1fff50cbc9f2765"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "328a96537077f11f766c02f621c3db4085a54707f86f216a6eb80a0300a5b01f" => :high_sierra
    sha256 "9ae99aa17b6d004dfe348c37aa7c602e06ca7228f54ff2ee0f8d324985e44938" => :sierra
    sha256 "fde10a7e1813dbeccf9af32d1b36776f15fc155b926837b5047481ab74178759" => :el_capitan
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
