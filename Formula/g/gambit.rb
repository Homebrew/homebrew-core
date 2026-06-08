class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "5d0ac6809841b02347b31accfb6ee31d6ae0593f33dcf58b71b9ca543b465fd9"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1981b508d7ec1e7f9bd9abd0f9cc604e1f0953b1261b9ad5478ab74dc13aff3c"
    sha256 cellar: :any,                 arm64_sequoia: "ca7a9c1c14a39a81072f117e3f4ccc89a41f1502d5be242c3aaea9574982eceb"
    sha256 cellar: :any,                 arm64_sonoma:  "917c3966b4a0b41a0e4dc605430eb816da5d48bc5bd585c45b96925e1c9f88da"
    sha256 cellar: :any,                 sonoma:        "04f5090eea9d0a69cf46f6e6c0f868394ab5470032b426b387accfb13d876b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bdcb2fd44695f5fe0ede13b74a9fb25bf400b5785de2c01eac50d9e6d98ecbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e73a3408e96fa4501a02949808f405324017d2acb50415cc11c77c252a2cb33"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets"

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-wx-config=#{wx_config}",
                          *std_configure_args
    system "make", "install"

    # Sanitise references to Homebrew shims
    rm Dir["contrib/**/Makefile*"]
    pkgshare.install "contrib"
  end

  test do
    system bin/"gambit-enumpure", pkgshare/"contrib/games/e04.efg"
    system bin/"gambit-enummixed", pkgshare/"contrib/games/e04.nfg"
    system bin/"gambit-gnm", pkgshare/"contrib/games/e04.nfg"
    system bin/"gambit-ipa", pkgshare/"contrib/games/e04.nfg"
    system bin/"gambit-lcp", pkgshare/"contrib/games/e04.efg"
    system bin/"gambit-lp", pkgshare/"contrib/games/2x2const.nfg"
    system bin/"gambit-liap", pkgshare/"contrib/games/e04.nfg"
    system bin/"gambit-simpdiv", pkgshare/"contrib/games/e04.nfg"
    system bin/"gambit-logit", pkgshare/"contrib/games/e04.efg"
    system bin/"gambit-convert", "-O", "html", pkgshare/"contrib/games/2x2.nfg"
  end
end
