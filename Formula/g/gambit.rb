class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "d72e991ce935a3dc893947c413410348e2c2eb9cd912ec3b083699a4ccae4d77"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6256d9e52330844dda1d10774c65a57368f5209548f2d5a9fbeb2bcdb84a91f1"
    sha256 cellar: :any,                 arm64_sonoma:  "f2895dba2b2a7ded50d39eb905ae51047dece63c9deb659175a3809edf3ded5d"
    sha256 cellar: :any,                 arm64_ventura: "dd3135d73ac6f13cb70dd512f0e814df73e5147aa9527a5dcc1ef70189a3b62e"
    sha256 cellar: :any,                 sonoma:        "222ccdc2f9b564c8c25fc3524745201634a892964ad325779661181dfbb28921"
    sha256 cellar: :any,                 ventura:       "c3a9408f35080bf0962de6843a662b8184d540a19e81f863131014d7923212d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87956816c0145f8e347b5a2b65ebb81a51146db66d8b326fd945bfddf48330a"
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
