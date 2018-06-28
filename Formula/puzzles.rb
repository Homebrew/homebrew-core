class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20180602.5a697b3.tar.gz"
  version "20180602"
  sha256 "b865a31efd5eb4caf5ad12e7f2c2a21897064d889b8c6cdac0c6cad45fcd54f6"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3b1c160953b815033d4cba3bab1e8b005f592e11b26ce0faf17d938f175af9b" => :high_sierra
    sha256 "9021de59633ecbcd09c21780397ec15b6c9c93ef86904f4fd73a144ac5805f99" => :sierra
    sha256 "5bf5d6a9c0c68f1ee5e13734141a51a028c931f32a581424c2a6eb3817606207" => :el_capitan
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
