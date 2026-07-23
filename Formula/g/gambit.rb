class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.7.0.tar.gz"
  sha256 "0d7c807b40cdc0d52c23e1585a4472da2c87ca63e306c4c00b55bf21841f9ce0"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0727eb839f30f8bc978b7deed309c23c7bff1be758f5acaa17c3ea79c76e9ca7"
    sha256 cellar: :any, arm64_sequoia: "c309326124d22ee43aef98998f01a8804c1a2c1ee5372bbee66d93c17dc9dd62"
    sha256 cellar: :any, arm64_sonoma:  "1e7fe6989b942d49e6cedffcede4e32eb982bf5f6eb01264ca832c7037e4e8f4"
    sha256 cellar: :any, sonoma:        "ffd11bbd944404a6a9f3a2d2f06df897ea72ae30c46f1b856012a0fbd2532b87"
    sha256 cellar: :any, arm64_linux:   "53f7dfdff2e9bdc1d53d30b03f00e822bc3995900f53530bdcd73130c16ed858"
    sha256 cellar: :any, x86_64_linux:  "695ba8a45f1c897a7c3c913e7c26cbad9e254c1ad88a76915c4d5db845dd19de"
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
