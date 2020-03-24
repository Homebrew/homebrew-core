class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200322.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200322.tar.bz2"
  sha256 "207484e124860e215cc3e4d7aff48b3b1c4376c95b3c7c7888453c67e92be94d"
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
