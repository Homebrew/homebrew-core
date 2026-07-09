class Gambit < Formula
  desc "Software tools for game theory"
  homepage "https://www.gambit-project.org/"
  url "https://github.com/gambitproject/gambit/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "5d0ac6809841b02347b31accfb6ee31d6ae0593f33dcf58b71b9ca543b465fd9"
  license all_of: ["GPL-2.0-or-later", "Zlib"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b18fff02fbf4346df57aaf20a158acf9c3c5ad7c88c15f467387faf95f312490"
    sha256 cellar: :any, arm64_sequoia: "b9817518732cfb5121715625eee81ef4aa51b03b8ad2f9a68f036bb460692519"
    sha256 cellar: :any, arm64_sonoma:  "822c07e3d9266d1227018452064d552e86c465639291c052d1bdc1431b706c70"
    sha256 cellar: :any, sonoma:        "498d1f98945326f9718e40da295d5a7f2797219a29539cac0a9b0a450859479d"
    sha256 cellar: :any, arm64_linux:   "e4429446170769d07bc4438ccd9a0d48041b68748cea76bee84338a8028e1b7d"
    sha256 cellar: :any, x86_64_linux:  "7c176f5cf12f389fef4123e6fe3bcca3224bb83bfd9179178af3e4715df6ccea"
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
