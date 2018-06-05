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
    sha256 "328a96537077f11f766c02f621c3db4085a54707f86f216a6eb80a0300a5b01f" => :high_sierra
    sha256 "9ae99aa17b6d004dfe348c37aa7c602e06ca7228f54ff2ee0f8d324985e44938" => :sierra
    sha256 "fde10a7e1813dbeccf9af32d1b36776f15fc155b926837b5047481ab74178759" => :el_capitan
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
