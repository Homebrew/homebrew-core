class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20200524.66b9e8c.tar.gz"
  version "20200524"
  sha256 "0509039291b384d85835e726ac0db9cee850e9466da01f96be35e046a3869358"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f236b75458f6bff7ac8ce9e6372f1587a771c9cb58d51a23158609c27db066de" => :catalina
    sha256 "315631a0710e349c3b65c1ce176e1ae3fdbd598b0a8b077da2b32f5b404ed72d" => :mojave
    sha256 "25c6d1412caef61b381b5b3b73aba66834f72197d8488a55a87b5694430e6d66" => :high_sierra
  end

  depends_on "halibut"

  def install
    # Do not build for i386
    inreplace "mkfiles.pl", /@osxarchs = .*/, "@osxarchs = ('x86_64');"

    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
  end
end
