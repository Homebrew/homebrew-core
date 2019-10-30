class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20190902.907c42b.tar.gz"
  version "20190902"
  sha256 "5aad2076f1b748a854f1590f31fbcfc23cc91bf08ce4a3f270bad7cd11e6766f"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c944e8c995cd9d879db7a28b33d65779994dc9fa418f7c401b213227e143306a" => :mojave
    sha256 "c162dc7ae06d5478e804c2d688d7c3db565476970af1f135de033b57dcf04a0a" => :high_sierra
    sha256 "2b671472249f97d37bd91ac62d3a320ebcb09cc9fff140477092ff2578ea9d00" => :sierra
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
