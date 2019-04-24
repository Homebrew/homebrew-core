class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190422.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190422.tar.bz2"
  sha256 "b44bedadff56936f05995ca54628a45ff528df5a59e37affb8f2ee00ad2bb475"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9695ade41d9165916bedfc93efa7ce7985332d6c9081a64ea299a4e0a6b63ec9" => :mojave
    sha256 "9695ade41d9165916bedfc93efa7ce7985332d6c9081a64ea299a4e0a6b63ec9" => :high_sierra
    sha256 "8c0d1446d701f007125cf185f95f3facaddb23338ab2f568a8669b1c932e6025" => :sierra
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
