class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.2.0.tar.gz"
  sha256 "cf8f36c7031834287a5fdde01af0845065706b11e6388087ef4303b6025221ec"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "15b1cd198277ba97c5d0b78984ae3c0c45f0d657145cd14eb4c0a3e809a80dee"
    sha256 cellar: :any,                 arm64_sonoma:   "985873c30cbbd722dff28874ebbdeb3e9922eecd232e7290b75e94c208a493c4"
    sha256 cellar: :any,                 arm64_ventura:  "5d6a7d78addc7083d7b5f15484150750779e2ce484f21e4f7f5d6c0ccb838bd8"
    sha256 cellar: :any,                 arm64_monterey: "e6f5a8bd927aa99ead958ca5869a2bcf7baaf5b196942cdfbdf4a132da4299c2"
    sha256 cellar: :any,                 sonoma:         "93075f364cfda3bd6b6fae4712017bda5ece8970c7310c6ffeb946eebe6db6f8"
    sha256 cellar: :any,                 ventura:        "acbdb8f054368360219bd7bcb33fbbdae6f07f88a30dbe9820f842e6c5ae6c75"
    sha256 cellar: :any,                 monterey:       "dbc4830a4a97d6836ea77d7152abf3e7ebc20a67f73d1fe1329c64b0d99f168a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ed956661c53f5a426261ec29f9b8aa06ec7c9c370d1265348a22733382d7b2"
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
