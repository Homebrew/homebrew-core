class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20181122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20181122.tar.bz2"
  sha256 "2f06580c833ca30f434511ea28a0c097e75e3ee35a87b3a58512bd6d5cf598d5"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d85920d1baddd367b7865f3adb78a63ddccb4bc8951f39274e5053d017dd55c0" => :mojave
    sha256 "42164d7be49e993dd7a972c0f9920c0aa3e31cb56949cf50808b844945295394" => :high_sierra
    sha256 "42164d7be49e993dd7a972c0f9920c0aa3e31cb56949cf50808b844945295394" => :sierra
  end

  if Tab.for_name("moreutils").with?("parallel")
    conflicts_with "moreutils",
      :because => "both install a `parallel` executable."
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
