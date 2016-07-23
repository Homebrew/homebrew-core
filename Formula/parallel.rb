class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20160722.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160722.tar.bz2"
  sha256 "e391ebd081e8ba13e870be68106d1beb5def2b001fa5881f46df0ab95304f521"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcd37ec306484b188dab6c647aa9175dffe23838671ea32439d236257a156301" => :el_capitan
    sha256 "717addcd009ba67c5dc6aaa2699c6675a1ada4d3721de868e1912fe8da14e6fe" => :yosemite
    sha256 "2d3a5e538c2434753e6532b36f33080730ea3e5a16cff268287f647bde56db84" => :mavericks
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
