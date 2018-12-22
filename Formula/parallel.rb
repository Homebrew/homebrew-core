class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20181222.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20181222.tar.bz2"
  sha256 "058c9f7cf599652aef5b54cf5c95c9a5b6d57d59ce4deebebf7938f7be4da369"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e15c960dcc3d1685493edd7d64e0733e15cc54a7715f286089e0d4a8f9ab09d" => :mojave
    sha256 "b7dae5354d62c318201f2df86bfcca2bf9d34ca74b24646353668e596cc2a2bc" => :high_sierra
    sha256 "b7dae5354d62c318201f2df86bfcca2bf9d34ca74b24646353668e596cc2a2bc" => :sierra
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
