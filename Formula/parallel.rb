class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200222.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200222.tar.bz2"
  sha256 "269b7236ec0887167ee7bc76357689b5c86e3dfbd5a1b3745d218526a038eb1c"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50de553453b0609213a33917337d7fafc491a66837f5d05b4a1e15dbed566a08" => :catalina
    sha256 "50de553453b0609213a33917337d7fafc491a66837f5d05b4a1e15dbed566a08" => :mojave
    sha256 "50de553453b0609213a33917337d7fafc491a66837f5d05b4a1e15dbed566a08" => :high_sierra
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
