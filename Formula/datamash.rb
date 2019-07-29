class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.4.tar.gz"
  sha256 "fa44dd2d5456bcb94ef49dfc6cfe62c83fd53ac435119a85d34e6812f6e6472a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6df5d507e7486fd57449ff0a7c53fe7dda265c27ffbc3becef14fc7ecb5b0a2" => :mojave
    sha256 "10bf8d835e2cc4401875db546d0336563f259fb9fc5cae86e58d91ede2cff943" => :high_sierra
    sha256 "35bf3994eb36de7e6f7c9e7010322c58aeb44e42676060c5b28d92f97789dfab" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
