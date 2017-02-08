class GnuGo < Formula
  desc "GNU Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftpmirror.gnu.org/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"
  revision 1
  head "git://git.savannah.gnu.org/gnugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fb1f3a416c5c2073ca72c5deeba248b9c81d357558a7315221dcf3634303203" => :sierra
    sha256 "cf02936086b6da588fab4b8e9c5e000b0d9fd78d7ab45a6b3202e55026408b7d" => :el_capitan
    sha256 "2d0a130fba94f47f80815f3c6da5c9ceeb45e7190972185ae275a8647305e39d" => :yosemite
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
