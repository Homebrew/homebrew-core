class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "19693666276aa6defdcb32be7eb4e2fcd965dcb1acefbe7fad96053ee3a46ada"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07b45fa28f0cff285c25115f5e4c8f28563a5e97495102ae7d2f56766c409814"
    sha256 cellar: :any,                 arm64_sequoia: "35b024541680ac9d0e07d6e48a32dd7441330eb42c5e6ba26cdce31c1cdf9312"
    sha256 cellar: :any,                 arm64_sonoma:  "0baf2d120e8c91337b951877e0a78a330a1223cd889fa7dc1e6aadba46372b3a"
    sha256 cellar: :any,                 sonoma:        "135e56b8549ff2b4b80446a65980ecadb5f2170d7e083124fd3fa5628ffb6b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0515813bdcbc1ba0d699de5eac0003b32adb865f43362dfc469420bc886df14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8998d9006ff244d16b87675a92ab015b86640bffcf71009be652fe9c2b8469b0"
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
