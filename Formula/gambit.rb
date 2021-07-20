class Gambit < Formula
  desc "Software tools for game theory"
  homepage "http://www.gambit-project.org"
  url "https://github.com/gambitproject/gambit/archive/v16.0.1.tar.gz"
  sha256 "56bb86fd17575827919194e275320a5dd498708fd8bb3b20845243d492c10fef"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8baa71e381f33562fc0580da41d111451900d28d20e162d0d86b82d10a8e21a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c036470f1e05014eb81ed12d66897c67501e51aa82569e928bf645ff273f6d98"
    sha256 cellar: :any_skip_relocation, catalina:      "4847905d44b80902b4d059b37bbf22aff4f1a4a760270aea1db539b3632a93ab"
    sha256 cellar: :any_skip_relocation, mojave:        "34ab61a2b2a66ee44a9098e49c519eab78e90d11029abe027844f7d3a341ab22"
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
