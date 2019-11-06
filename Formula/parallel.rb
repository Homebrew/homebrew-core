class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20191022.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20191022.tar.bz2"
  sha256 "641beea4fb9afccb1969ac0fb43ebc458f375ceb6f7e24970a9aced463e909a9"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0953e1de25a1134d5ecc2aba16dfa8ecef6a609984ffaa3614ddd37c966ec3" => :catalina
    sha256 "6b0953e1de25a1134d5ecc2aba16dfa8ecef6a609984ffaa3614ddd37c966ec3" => :mojave
    sha256 "6b0953e1de25a1134d5ecc2aba16dfa8ecef6a609984ffaa3614ddd37c966ec3" => :high_sierra
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
