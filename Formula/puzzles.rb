class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20190415.e2135d5.tar.gz"
  version "20190415"
  sha256 "5309fc9d7c4b7b2fe2db4ea68654c5952c02d13bbe7d0a7caa0c285cf79de90a"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c9074c13804af872034dfe44ecef1981c2ecd2f889e2321c285e29c5b5f44ba" => :mojave
    sha256 "3295675cb50bc1a1e4be0e3e58bc7841d85ff91a9cb3bcf30a034cfcc653239a" => :high_sierra
    sha256 "44bcf61171a8968e2eaa76f178f713ee74fda0922ad41aa1cc431631992ac456" => :sierra
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
