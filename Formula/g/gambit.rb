class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.1.1.tar.gz"
  sha256 "94f9cb2fe6f423f11397fd28746c5961eefc0b2223409886a2e14909bcc54f37"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b3169b385eb7487afe3e851728d7fb18a491c6edff70c3108abfea9a78a57bfe"
    sha256 cellar: :any,                 arm64_ventura:  "1add1778235e755be58d5f9dcedd73e19639f1df9a7db8814e14f7af8d9e79bf"
    sha256 cellar: :any,                 arm64_monterey: "c048fded4c4bf56ad82f9f0c81df73f337e1af260691c43f61a085218d1c8467"
    sha256 cellar: :any,                 sonoma:         "492d4d539d89677485346d83aa89a3979f5052474481b8407705ced1f333fa64"
    sha256 cellar: :any,                 ventura:        "37ee93bcbb9102b82658b9e0df9e29c554f239a50eefa3303a5605b97674172d"
    sha256 cellar: :any,                 monterey:       "8f9f32d44d7d7ba78d9852d835d247dc5419510eb9a911b3817aacde3d01db26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf139206bbe3ecedb5f604bd9e14d705ba50f5887d0d9db74a6d1910303e196"
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
