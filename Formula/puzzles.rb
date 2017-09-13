class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sgt-puzzles/sgt-puzzles_20161228.7cae89f.orig.tar.gz"
  version "20161228.7cae89f"
  sha256 "96b6915941b8490188652ab5c81bcb3ee42117e6fb7c03eed3e4333fa97ed852"

  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
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
    File.executable? prefix/"Puzzles.app/Contents/MacOS/puzzles"
  end
end
