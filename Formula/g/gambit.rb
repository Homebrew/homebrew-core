class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "19693666276aa6defdcb32be7eb4e2fcd965dcb1acefbe7fad96053ee3a46ada"
  license all_of: ["GPL-2.0-or-later", "Zlib"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08af0221f4432596af0261c4d346b4f3b92380f8317fdd3b297e5678084695a7"
    sha256 cellar: :any,                 arm64_sequoia: "f7dc644a3fbd42c0576604fc2e1330fe2098197d3bbd30be4e2ed216f9c66862"
    sha256 cellar: :any,                 arm64_sonoma:  "64491df3a8506e64c95a765d35bc4930b0f9db0fbf743701a7196e92db3da780"
    sha256 cellar: :any,                 sonoma:        "9a41b52cd8ab1a5f816c689eb3123905cddc9babb9afded1fef4662f631480ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c34be7773313956cfd194d423445a225831b6337de5fedaaa0b497bbbea5811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c06efc4a32359830544c6cd58e9b270427a21c2bf81b1e3aab311a5e386318"
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
