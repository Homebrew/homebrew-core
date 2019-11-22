class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v15.1.1.tar.gz"
  sha256 "fb4dce2f386e46bbfc72cb75471f43716535937c96ad5a730cad22f97c6a65e6"

  bottle do
    cellar :any
    sha256 "85c73c5372aa6bba15f651f9b0b5b3e5eaa790c83ba19159de8a0e8bca0e60fc" => :catalina
    sha256 "697370ba59d7b4a8e7f35e5bbfc3535ed6fef6d0a80a39e9e0583e7496865fbf" => :mojave
    sha256 "8419c4b938c3ee82df324d4e4fbc0de03302a973ebeb82b917c90be04fa10569" => :high_sierra
    sha256 "1d0324bc5c27cfe5660be48a8d2e7c9d01ac342e5d3ee1ee6d89f30b9c149afa" => :sierra
    sha256 "86626efb984f8bb90daca5421cfdb2cbb2b9669ac26b271d0381219e1374e1b2" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxmac"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "contrib"
  end

  test do
    system bin/"gambit-enumpure", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-enumpoly", pkgshare/"contrib/games/e01.efg"
    system bin/"gambit-enummixed", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-gnm", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-ipa", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-lcp", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-lp", pkgshare/"contrib/games/2x2const.nfg"
    system bin/"gambit-liap", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-simpdiv", pkgshare/"contrib/games/e02.nfg"
    system bin/"gambit-logit", pkgshare/"contrib/games/e02.efg"
    system bin/"gambit-convert", "-O", "html", pkgshare/"contrib/games/2x2.nfg"
  end
end
