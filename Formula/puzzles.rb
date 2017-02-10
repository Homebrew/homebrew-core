class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20140928.r10274.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20140928.r10274.orig.tar.gz"
  version "10274"
  sha256 "d8c61b29c4cb39d991e4440e411fd0d78f23fdf5fb96621b83ac34ab396823aa"

  head "git://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9803aa0125ef2ab48668305752edaea7b37ba80f122c6d8a721b801819a82027" => :sierra
    sha256 "9803aa0125ef2ab48668305752edaea7b37ba80f122c6d8a721b801819a82027" => :el_capitan
    sha256 "5bc665ab99098febf65f0c5765ae94cc43c07a1b930bda8b950001d8e1676237" => :yosemite
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
