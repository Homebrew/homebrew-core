class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.2.tar.gz"
  sha256 "c6ce84b421e7199ae545ea8b8d981f347af4d67b4cd5912b6789cf1450db722e"
  revision 1

  bottle do
    sha256 "1ca56de1c4771063323308f34678f4118f8d1c2ffc532dbbd331292bd56f9657" => :catalina
    sha256 "6d067038c65914ac316c860816b6d2a0c03eb29ccde03f7f799737b4bcb62d3a" => :mojave
    sha256 "b58b4f6913811db5fd8ac1e2c949198b4f2f67979679a33829e928654cbf6c0c" => :high_sierra
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
