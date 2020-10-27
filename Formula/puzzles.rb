class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20200610.9aa7b7c.tar.gz"
  version "20200610"
  sha256 "6e50becfe22f5b48d463293145a1b6dc8f7e7eb89de44c3cfe2165750e0b2d67"
  head "https://git.tartarus.org/simon/puzzles.git"

  livecheck do
    url "https://www.freshports.org/games/sgt-puzzles"
    regex(/puzzles[._-]v?(\d{6,8})\..*?\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ceafdd23c80d3b19927950e42b87589c577842e0617771cf3cda4696215ad201" => :catalina
    sha256 "0aefe3d23e5dc7a2a8ef7414b81f5ebc12566b0b712d67c7328f7ceec67bb6cb" => :mojave
    sha256 "e70e7726c99542aa47fd5ff918a121ca0967c3ef5ab4e69d026eefb63141d8ff" => :high_sierra
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
