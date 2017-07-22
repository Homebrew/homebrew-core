class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170722.tar.bz2"
  sha256 "bdc5b05a9e9df134d296ad7111ad7e1bfe5c7e1a2538d023ce8bcdd01728ef84"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae57e9a5744c3693188f420bd23e54db4fb2979d679ff32aafe2bab7dfe7dfbb" => :sierra
    sha256 "ae57e9a5744c3693188f420bd23e54db4fb2979d679ff32aafe2bab7dfe7dfbb" => :el_capitan
    sha256 "ae57e9a5744c3693188f420bd23e54db4fb2979d679ff32aafe2bab7dfe7dfbb" => :yosemite
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
