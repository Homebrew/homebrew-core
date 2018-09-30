class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20180924.d8d5064.tar.gz"
  version "20180924"
  sha256 "e040e965c52dd7b60603737e2530dda654b2d25f79d2a0a4ee06ab757e62ac6d"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "535f863dda75dd311e6d16372768097281ae6fe25d8a1f081dcba95de67067be" => :high_sierra
    sha256 "9d93a8a1cd45ef6a1dc5fbc752b0bd423ea72056ef090c180ba1294fd7eeb9fd" => :sierra
    sha256 "7a43c8742fbf291eac5338f0846d2fdb85c161323b11e025af9bbc3e2724030d" => :el_capitan
  end

  depends_on "halibut"

  def install
    # Prevent "lipo: Puzzles.i386.bin and Puzzles.x86_64.bin have the same
    # architectures (x86_64) and can't be in the same fat output file"
    ENV.permit_arch_flags

    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
  end
end
