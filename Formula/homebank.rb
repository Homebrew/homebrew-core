class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.4.tar.gz"
  sha256 "0af35f848c9be864db838868c14977e3f873b54b20be24b6b30189766c5afd1f"

  bottle do
    sha256 "66fac13d713d56d4d506797b85fc2f82f67da5007182d96a9d2d8483499c53e0" => :sierra
    sha256 "da0180fd6835b3f921cde03d80946184a4b77bc81f6d21b13806f59d56997a86" => :el_capitan
    sha256 "6df11deccc339311eb4f3623b2469edc6b2aba78312f2b633e51c61bc6affdcd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libsoup"
  depends_on "libofx" => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
