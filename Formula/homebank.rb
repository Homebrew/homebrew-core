class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/homebank-5.6.2.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.6.2.tar.gz"
  sha256 "12ebde58e04d3c18496f95496067c4e8841b0d111668d1f47c239292b15316f1"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b9318342348c5129433d9940c38a2d38f76b9e954983a5ece4a86f56d38e493a"
    sha256 arm64_monterey: "6564810170d4a8c5da1160fd532d89045c5309f6eaae1cfa02e32bd33f12e3d1"
    sha256 arm64_big_sur:  "c5d12b9fb502f8b919feb094238ef5a34df513a09e2a0ab0cf2682d710a9d18a"
    sha256 ventura:        "f72b3439318e1675752618739a259e2e3351e22657973237bdedee69b536b0ee"
    sha256 monterey:       "18b9f4fbc154071ced723cf6986a4523fab77d22a69391b21b8c61bfff2b9767"
    sha256 big_sur:        "302963210678fe1513936ea9830b9e38484fbbe48aec949ffc6323d7266d92bb"
    sha256 x86_64_linux:   "0c573d90129e5f6b0f5bc0bae6095844250eabd75837b0b86d675f14ef87953d"
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
