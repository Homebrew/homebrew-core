class GnuGo < Formula
  desc "GNU Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"
  revision 1
  head "https://git.savannah.gnu.org/git/gnugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b756b9307e6ff0a0cb9c05eca13ae12b3a9f6ee44219fa4a899e5301fffa2483" => :catalina
    sha256 "75ae8e3e46982c28060396ad4cfaab92c0072f7f8191e21fe9b5b53b157fac06" => :mojave
    sha256 "5e6ee72c1ccd877c08591680117bf73d809f6422ea9855596b286970d165c14a" => :high_sierra
    sha256 "25fa92bd5c129cb655ec06c441523ada5cbc90a560111c32f5b1246c8f7d124c" => :sierra
    sha256 "f845be5a48a89cf0e46322b4d3a64a86b9fd4793f6b98fee0c45de5e8e5eda69" => :el_capitan
    sha256 "57731f2cb8dcb2959e85baebdb779989390688a70447b923b9d5c1ce8575da44" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline"
    system "make", "install"
  end

  test do
    assert_match /GNU Go #{version}$/, shell_output("#{bin}/gnugo --version")
  end
end
