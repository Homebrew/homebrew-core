class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20210422.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20210422.tar.bz2"
  sha256 "be3e6a3b644467bef25905cb4fd917e67eef982ba4f6e258df25bb0235b59ee8"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70e9f1209b6a70c2832f5e4a90e5eed0a20ca08509612d8d5b4dc52cbd156ef7"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fbd9a31cd90ab4f822040f0a93498b1717e8adf720862ab818f728dd3f55af9"
    sha256 cellar: :any_skip_relocation, catalina:      "0f9dbc42951f85bfd4945729347b455e4eccc4bf581182bdaf6412478e27dae4"
    sha256 cellar: :any_skip_relocation, mojave:        "63f756a786d1cdecb8493abc9da40c9cc07c7e4c16830f971c8031f2bc1f0c37"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
