class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.2.tar.gz"
  sha256 "49837f2ccb9bb65dad2f3bba9c436c7a7df8711887e25f6bf54b074508a682d4"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5de5e2b1de2ed63312ece5a6f674df1d38d01b720910c89ab12e732d3de56e40"
    sha256 cellar: :any,                 arm64_big_sur:  "c97e03ee045fc6cb0df0f0cfb3812b9037524765a3adcda3ffa47358b8c242b4"
    sha256 cellar: :any,                 monterey:       "b4a0e0e82274595c8be7e31229cd8fd2eee7db7eccc3519c9c06b243dc7d33e2"
    sha256 cellar: :any,                 big_sur:        "c3f908600efd465c3857f5f0a9f14367e057f37119c554fdf165632fc87ed777"
    sha256 cellar: :any,                 catalina:       "908361fb788eb07b5eb5d4d54377c23ad995ee55b509d5f40b75b988ff1bd445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05dfaa8cfe56c8c444af6ee95abf4a04ba00ab69db38cb877f0c1d0812e336d0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-wx-prefix=#{Formula["wxwidgets"].opt_prefix}"
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
