class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.4.tar.gz"
  sha256 "0d0669bca099340ae5c213ea13cb2b93283bfc8a0e4cf7a5902c1829366e5765"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dfd2e97743a1d6e885d09896eb670fc544d2ceb3543c1699c5e600952718d0da"
    sha256 arm64_big_sur:  "248b22f8e95324466e5a30e569276ae9c16accfc83ca1ff9809457b196d24dfa"
    sha256 monterey:       "e56e97a9790103d68ecb12fe81224420c637ff423c41ad849493c3c71a809281"
    sha256 big_sur:        "2fd1d508d0d5cd2b6a964f0a7cfb58b13ff9cea16d61744ad335ecc555e87af3"
    sha256 catalina:       "0ba4929a2d40019f7b160257f49fbf3545313cf716865648eb255e8cf2062418"
    sha256 x86_64_linux:   "436c0579be3d4d4e937d7c03e3c5bb55d41e8322611a23198af24a837856670b"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup@2"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
