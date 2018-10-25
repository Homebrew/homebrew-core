class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20181022.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20181022.tar.bz2"
  sha256 "2e84dee3556cbb8f6a3794f5b21549faffb132db3fc68e2e95922963adcbdbec"
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
