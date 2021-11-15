class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.1.tar.gz"
  sha256 "56bb86fd17575827919194e275320a5dd498708fd8bb3b20845243d492c10fef"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b92ff6853ffbf21cb1999cce85620f289cbaeecb51b06c219eff10afe839794e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "067cb4ce13d125296e4db92c28c63ae90c6107079b8cd4a6e1fc935565bf864f"
    sha256 cellar: :any_skip_relocation, monterey:       "c35cdfa436f76f4054c666b8b2e7ea4b72c1afd22c169c32eef2e32e1d5bafe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c99a930bc6bd33cd8ccd07602c472c9a64006b8a6ca2a846081c0faecaf39bf7"
    sha256 cellar: :any_skip_relocation, catalina:       "ca119805ce3e9aa8a02d91362ba8cab410762b34e84c67616c78006acebd7d44"
    sha256 cellar: :any_skip_relocation, mojave:         "0ed6547bd2c50529879b3f1d19dcd1afa685dcc3ed030866d6cbd104c6402dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946f395529bd8d582781d198adac36c2617b0636db95b8b7b5337d0542f0f7eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wxwidgets@3.0"

  def install
    wxwidgets = Formula["wxwidgets@3.0"]
    ENV["WX_CONFIG"] = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
