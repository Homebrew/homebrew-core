class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.2.tar.gz"
  sha256 "c6ce84b421e7199ae545ea8b8d981f347af4d67b4cd5912b6789cf1450db722e"

  bottle do
    sha256 "19428dfc7ea700df634f4200cfac4d5dad97e000e6ba82a5803bb6a369875e0a" => :catalina
    sha256 "6a4b542966723577d7ceeffb20d05bdfa853ffcf93862b7716a0d7cd8ec8e604" => :mojave
    sha256 "18ce681d781685ca73e785040d4750b447b4ed3c44f7f087c7d4f8525089d9c7" => :high_sierra
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
  depends_on "libsoup"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
