class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200822.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200822.tar.bz2"
  sha256 "9654226a808392c365b1e7b8dea91bf4870bc4f306228d853eb700679e21be09"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :catalina
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :mojave
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :high_sierra
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
