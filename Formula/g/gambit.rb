class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.4.0.tar.gz"
  sha256 "e8e3b07c45b51c94e089e2ea4a349de692f897b0720db7a212afc3961517a77d"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "fda19472e7338d469ab502354f841d7274da2ad58fbdcebca31cbe7cd2691373"
    sha256 cellar: :any,                 arm64_sequoia: "a756abfae652920468ccc33ed14b6d2d35ca0514b3edd557c474b75f16aedc28"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b2b719786a00453e0b2c00b0e31d9a78330774a366ca4152bd620eaefb5f24"
    sha256 cellar: :any,                 sonoma:        "10f1e8d813afaa98c88966f56bae72de8849ef801f338e74e989620e0d42fc6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c7bce83a2e06e9dbf842b15ddababe48c266dd58bbc7889a6d9ecd8675c80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ed7b5b6f8a265a7f6e92c2477d6d0ff7d2bb0598b33fbc3d789f3f8f6c3d87"
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
