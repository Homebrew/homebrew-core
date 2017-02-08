class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20140928.r10274.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20140928.r10274.orig.tar.gz"
  version "10274"
  sha256 "d8c61b29c4cb39d991e4440e411fd0d78f23fdf5fb96621b83ac34ab396823aa"

  head "git://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any
    sha256 "c81998464a7c05a2b0c8388d2719b02f22874bf14b83b61c947fbac1d9dfd23d" => :yosemite
    sha256 "d0ef8a9ea7b3a395557d20c64ef0e7301c8fd62caca5f9e5084f4fb9542dd439" => :mavericks
    sha256 "91aceb93ef4d2369588f7de865654e7617eb4f6e4f99fd97ee633220c932ede6" => :mountain_lion
  end

  depends_on "halibut"

  def install
    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    File.executable? prefix/"Puzzles.app/Contents/MacOS/puzzles"
  end
end
