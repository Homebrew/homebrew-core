class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "d72e991ce935a3dc893947c413410348e2c2eb9cd912ec3b083699a4ccae4d77"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d169d9513ebda3d8fdbd1d0bda57ac1efd0c7782fc4ed0bf17f8d181e516ec9"
    sha256 cellar: :any,                 arm64_sonoma:  "f4da9b72e58e25666c95f27f3edd1aa11dd9971b37b95acfdda2fa93b5312e5b"
    sha256 cellar: :any,                 arm64_ventura: "533a277aa08b5f731b6957ff8d00d80b294f2a0e3ec037a0dc1f77fd81ead4d6"
    sha256 cellar: :any,                 sonoma:        "bdc37ba41b63d856e08bee3f1d6734ac58e56bcc97de32237b463d5fbe5bd54a"
    sha256 cellar: :any,                 ventura:       "0a6d66fa03abd6e602b323f00a1129e0e3108555d74bb0d7185c3b36632a61c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "486472d9ca1190ff759962d43c6aaada0c955f0a901ddb54fd4ddd2a4d9388bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6139ef89bc115c921b542feba6a74d4434c75c3467598461862898563c8459f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-wx-prefix=#{Formula["wxwidgets"].opt_prefix}",
                          *std_configure_args
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
