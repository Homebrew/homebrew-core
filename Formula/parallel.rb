class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180322.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180322.tar.bz2"
  sha256 "6389ad5318247ea28a8e9ddc9e69bc2713ae5c19e3783edda81da54ff6356497"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4479a702c0e9906a6b6d2f93c5ba808e116251ccb54a438f4490694a3485ac56" => :high_sierra
    sha256 "4479a702c0e9906a6b6d2f93c5ba808e116251ccb54a438f4490694a3485ac56" => :sierra
    sha256 "4479a702c0e9906a6b6d2f93c5ba808e116251ccb54a438f4490694a3485ac56" => :el_capitan
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
