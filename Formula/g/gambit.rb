class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.2.tar.gz"
  sha256 "49837f2ccb9bb65dad2f3bba9c436c7a7df8711887e25f6bf54b074508a682d4"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "183dc5a8d5d31cd73296b04216727a1049cebb34788f1b58c421536a6d9d9d36"
    sha256 cellar: :any,                 arm64_monterey: "9e8a6532979a76099a1aec227b3b581f72ace90d5d6df95ef92a9aee4695ea91"
    sha256 cellar: :any,                 arm64_big_sur:  "8095ee116fc0670d6f2a162851c65bcfd975bafdb728c3a7748a09a59f09c72b"
    sha256 cellar: :any,                 ventura:        "7c088cdd93af9aa729243909d2f0d1b6b4d04e2893c5b49293f22ea1b75a9059"
    sha256 cellar: :any,                 monterey:       "bcfcbfc39abea04e9a9f724ac800042003ce9d3dd56a9bab77615825032e0ef0"
    sha256 cellar: :any,                 big_sur:        "57c1e208efcda541d09673f8852ef2903a5bae47ddfcaccfcfa5b42b9f46070a"
    sha256 cellar: :any,                 catalina:       "a05c834248ab760aeffe219b232ef13c10e002350e91bde1bfa4259bbb879d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ebe528c6a77da1d27ad4460732d11bc0daddaf4a7afe2a4db0e0af96991f0f"
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
