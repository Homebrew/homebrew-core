class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.2.tar.gz"
  sha256 "49837f2ccb9bb65dad2f3bba9c436c7a7df8711887e25f6bf54b074508a682d4"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41bbabeace9094509b989c0c9927766bf9152ac536141af8a9192cecc28fad48"
    sha256 cellar: :any,                 arm64_big_sur:  "e7ad1df8904644a889496a9080ff1b988521daee6e39b701584ac78a9be70408"
    sha256 cellar: :any,                 monterey:       "20a9da764deb1412b480a02594f73f11f3ea30096e00532550b31d1b7097aeed"
    sha256 cellar: :any,                 big_sur:        "48efe04b8b27733e94777c0a1f0d87474718075b8591ff08913a475070cb9ec9"
    sha256 cellar: :any,                 catalina:       "1ed09ec20d96eb987aa568a26cf2203386d99b01ff3603de632ad20ef6948b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e129d1fdcd1a734e96c5c73517760465e35b178895081f09c9d172524f2fbf"
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
