class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180922.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180922.tar.bz2"
  sha256 "ea078ef0e0528c9b5d1c60bf6cf8454ce7586521982c677a450e0baff8a7071f"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6131a9672f6c616f7a48a5f2d341ebc64b96b93f83ec72d4c17c0a3852c39c8" => :mojave
    sha256 "2c7ae3a80fde400d718ce7a66f9dcc2ff7c2cf32afe174eefaf246d1223f59e4" => :high_sierra
    sha256 "2c7ae3a80fde400d718ce7a66f9dcc2ff7c2cf32afe174eefaf246d1223f59e4" => :sierra
    sha256 "2c7ae3a80fde400d718ce7a66f9dcc2ff7c2cf32afe174eefaf246d1223f59e4" => :el_capitan
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
