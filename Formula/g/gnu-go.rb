class GnuGo < Formula
  desc "Plays the game of Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"
  revision 1
  head "https://git.savannah.gnu.org/git/gnugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d51049554c942b464d900b5bd264c2606af4775cec9c4c76cf1c170beefe91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed049166ae53dc93586ab3ac5b3a3b40209dc46c9acaec335683a6c6b2c104ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93fd32bdebd46174fe9d1ff0572dea0859c0a9f29dad7d9e20097da446cea7ab"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6a55c92da6fc437dfc599fc84ec2a1f0e53d069efbfcb335d6a78da06d9177"
    sha256 cellar: :any_skip_relocation, monterey:       "b9394ee3acacef9bcb2c8df6a9fdd7547c99af2c0fd81f1dc1faa9e1b35c94df"
    sha256 cellar: :any_skip_relocation, big_sur:        "41b40531006a8e8c83d81b0c7628b7bd25a946e9d322e0ac8d5b5a91c999c0d4"
    sha256 cellar: :any_skip_relocation, catalina:       "b756b9307e6ff0a0cb9c05eca13ae12b3a9f6ee44219fa4a899e5301fffa2483"
    sha256 cellar: :any_skip_relocation, mojave:         "75ae8e3e46982c28060396ad4cfaab92c0072f7f8191e21fe9b5b53b157fac06"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5e6ee72c1ccd877c08591680117bf73d809f6422ea9855596b286970d165c14a"
    sha256 cellar: :any_skip_relocation, sierra:         "25fa92bd5c129cb655ec06c441523ada5cbc90a560111c32f5b1246c8f7d124c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f845be5a48a89cf0e46322b4d3a64a86b9fd4793f6b98fee0c45de5e8e5eda69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e7447f557b3af1f8c1e56d9a30cbe4315bd9f05ec734fb2fadac5887ab0474"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline"
    system "make", "install"
  end

  test do
    assert_match(/GNU Go #{version}$/, shell_output("#{bin}/gnugo --version"))
  end
end
