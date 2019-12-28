class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20191222.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20191222.tar.bz2"
  sha256 "fe29e9be6637c82b6cf7b3726e32b760c86b1115ff58810663490342d0297c77"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3612b7077dfa5d67d13e66c77680eaeb876f397f79724c90eefe9f7291fc8892" => :catalina
    sha256 "3612b7077dfa5d67d13e66c77680eaeb876f397f79724c90eefe9f7291fc8892" => :mojave
    sha256 "3612b7077dfa5d67d13e66c77680eaeb876f397f79724c90eefe9f7291fc8892" => :high_sierra
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
