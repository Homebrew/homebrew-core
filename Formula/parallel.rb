class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200122.tar.bz2"
  sha256 "116f1e428da5cdb26cda3ee5f249bdb20c5f96f139c0a284ad142919d6d80c1c"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e3389e32e42deb008a3a03ec8a3ff35f021c7f1612aa23f3ce9ceba3db336b5" => :catalina
    sha256 "1e3389e32e42deb008a3a03ec8a3ff35f021c7f1612aa23f3ce9ceba3db336b5" => :mojave
    sha256 "1e3389e32e42deb008a3a03ec8a3ff35f021c7f1612aa23f3ce9ceba3db336b5" => :high_sierra
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
