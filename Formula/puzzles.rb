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
    rebuild 1
    sha256 "a961496e5300cde27bc88ebca82dc1e75a03f2d15025ffa48c243a4aa1792f0a" => :catalina
    sha256 "a961496e5300cde27bc88ebca82dc1e75a03f2d15025ffa48c243a4aa1792f0a" => :mojave
    sha256 "420e204a6170b7e2d1a4318bb96817a738a5a4cd3bec383e1ca7c3aed4602800" => :high_sierra
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
