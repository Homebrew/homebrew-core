class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190522.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190522.tar.bz2"
  sha256 "5bc60a65902102eb080690cd4cf168bc99f74a467ee9c7ff98ea0dbd3c4f7f78"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db9c56f3e2d8603975441b7b45acea082919309b2a8d92e9eafbd96b03b8d13f" => :mojave
    sha256 "db9c56f3e2d8603975441b7b45acea082919309b2a8d92e9eafbd96b03b8d13f" => :high_sierra
    sha256 "f82c897d474f83defa00f9d47c3f02ee26bb8e662b8b29595313c2504134068d" => :sierra
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
