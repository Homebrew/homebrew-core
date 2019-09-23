class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.8.tar.gz"
  sha256 "fe98a3585a23ed66695a96b9162dbf1872f4fd78c01471019b60786476bc558d"

  bottle do
    sha256 "720811ca34532edca14d9f57ac96743c96ea437f322badba59f34f21995f8743" => :mojave
    sha256 "00508ac30105e87b4710aa394348a0b7404bcd0806e1c421472df9a4be3baff2" => :high_sierra
    sha256 "645c65fca78a4e3f2818a79ca450b833901f00e8b142d7a709f2a3ffb1d88791" => :sierra
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
