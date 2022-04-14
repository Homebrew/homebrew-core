class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.2.tar.gz"
  sha256 "49837f2ccb9bb65dad2f3bba9c436c7a7df8711887e25f6bf54b074508a682d4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0779354b7180b2a9ef458329b0e9e7479ba124a1682f9f6068c2eef9837b96d6"
    sha256 cellar: :any,                 arm64_big_sur:  "f528e0b09dd94b129e8e6a37b1ac7b881b5f94602b4c7dd73c3f9304fc3f461a"
    sha256 cellar: :any,                 monterey:       "65e3c4196da9261bea2df1694700ed9dfca563f8390269c9e85d7e694d4e9679"
    sha256 cellar: :any,                 big_sur:        "9a13115f4a60933306b00fef69aa5b020b6fbe60b19291c73515c908bfce4464"
    sha256 cellar: :any,                 catalina:       "43e0f79f7009fae5cea81be024b0bab1a7f9dd444da8ac43cb78cac10d0c3ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "551f35c78edac8bc7a7e62511c7f9bb34b6143211b56ba00b3d9931b0ca96504"
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
