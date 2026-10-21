class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/releases/download/v16.7.0/gambit-16.7.0.tar.gz"
  sha256 "35a2d7df4f8181cb216ce9a2b10ca820724768d8c69787a608a4a2725a745278"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f46acacbe1b2876f9e40c0302a4a1450d41e918a6f18330940fef2f25e6f5030"
    sha256 cellar: :any, arm64_tahoe:       "bfdbad8876f7eff5732d31db66adfb98272a4e72f08da46aa19e9f1e40f65203"
    sha256 cellar: :any, arm64_sequoia:     "d1247f5d4adb15e628ef6aabf123aae33f5f813a0562d1038542590d42f23df1"
    sha256 cellar: :any, arm64_linux:       "0a2e15bfe04acb20cf5519f6dc346b079880a0bac3c8599da5fa1e9669cd502d"
    sha256 cellar: :any, x86_64_linux:      "e8a5dac55b39e52e558c2447b44d1af9581b70d2cf34823d2ad5acd5851fe0eb"
  end

  depends_on "wxwidgets"

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
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
