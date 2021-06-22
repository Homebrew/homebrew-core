class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.1.tar.gz"
  sha256 "56bb86fd17575827919194e275320a5dd498708fd8bb3b20845243d492c10fef"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "45b7d50d9ab796456c5688aabcffa048f39c5d8698e914f2c9d4d308d1f795a9"
    sha256 cellar: :any, big_sur:       "e5b2c33a83a81fedeaf73e1e62186864a52031c6046fb7a69f2d5a0e44d881f4"
    sha256 cellar: :any, catalina:      "05ab5f78b317c4128110507c07b8eb94914361624248defae542008d9a9d62d5"
    sha256 cellar: :any, mojave:        "74b93be01bbbdd562b00977b6d3f442c0edcfde923ab973c1c62b61e9afd33ad"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxmac@3.0"

  def install
    wxmac = Formula["wxmac@3.0"]
    ENV["WX_CONFIG"] = wxmac.opt_bin/"wx-config-#{wxmac.version.major_minor}"

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Sanitise references to Homebrew shims
    rm Dir["contrib/**/Makefile*"]
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
