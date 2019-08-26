class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190822.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190822.tar.bz2"
  sha256 "77eaf5b58830c23e9607ced9e8a916ac4e17f40cfc86f224289df1e6505023d6"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce97983549eeeedfa6d3c1b82e8ec645851f33d7330975ab21f420f188c2c086" => :mojave
    sha256 "ce97983549eeeedfa6d3c1b82e8ec645851f33d7330975ab21f420f188c2c086" => :high_sierra
    sha256 "4f4aa2e7fb43efa2b246a96974288ec5c55e3878737bfa4c707185fb5f99cb8e" => :sierra
  end

  conflicts_with "moreutils",
    :because => "both install a `parallel` executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
