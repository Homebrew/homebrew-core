class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v15.1.1.tar.gz"
  sha256 "fb4dce2f386e46bbfc72cb75471f43716535937c96ad5a730cad22f97c6a65e6"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxmac"

  def install
    system "aclocal"
    system "glibtoolize"
    system "automake", "--add-missing"
    system "autoconf"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    share.mkpath
    share.install "contrib"
  end

  test do
    system bin/"gambit-enumpure", share/"contrib/games/e02.efg"
    system bin/"gambit-enumpoly", share/"contrib/games/e01.efg"
    system bin/"gambit-enummixed", share/"contrib/games/e02.nfg"
    system bin/"gambit-gnm", share/"contrib/games/e02.nfg"
    system bin/"gambit-ipa", share/"contrib/games/e02.nfg"
    system bin/"gambit-lcp", share/"contrib/games/e02.efg"
    system bin/"gambit-lp", share/"contrib/games/2x2const.nfg"
    system bin/"gambit-liap", share/"contrib/games/e02.nfg"
    system bin/"gambit-simpdiv", share/"contrib/games/e02.nfg"
    system bin/"gambit-logit", share/"contrib/games/e02.efg"
    system bin/"gambit-convert", "-O", "html", share/"contrib/games/2x2.nfg"
  end
end
