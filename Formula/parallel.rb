class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20171222.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20171222.tar.bz2"
  sha256 "9bc8c7fd2420ee9c6f4eeaf11d08c77682dbb02dc64d64881f38110f693379dc"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1589809ceef53ad31049229936f0412155ef8c72efec9df1abffc8daaa3d15d" => :high_sierra
    sha256 "c1589809ceef53ad31049229936f0412155ef8c72efec9df1abffc8daaa3d15d" => :sierra
    sha256 "c1589809ceef53ad31049229936f0412155ef8c72efec9df1abffc8daaa3d15d" => :el_capitan
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
