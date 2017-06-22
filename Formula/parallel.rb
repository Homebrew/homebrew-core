class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170622.tar.bz2"
  sha256 "b3324ca1e7553b9903e0ab1fbb461334986eadfcd9b33e09013a6bac3c279645"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6152111a96cef8945a58d96e6b8fa91931d9d25bc33a4e01e93169fb3966fc08" => :sierra
    sha256 "51102dc5bbc06d65178b38a49cee9088ccf9b693c7bc52e998abce7d3384a68b" => :el_capitan
    sha256 "51102dc5bbc06d65178b38a49cee9088ccf9b693c7bc52e998abce7d3384a68b" => :yosemite
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
