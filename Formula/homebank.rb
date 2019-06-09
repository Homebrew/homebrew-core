class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.6.tar.gz"
  sha256 "9a14cbf7029080f208d76b27a2d8066964426685ddc86fd1abed30bd428c9881"

  bottle do
    sha256 "7f48497d3f19944b86dd649d221fd58977245b0b777ebdc01c158838694de27f" => :mojave
    sha256 "c76bf5540cde818a83c0011d361e09dee1a929c0094af7de37897ec15c6e0018" => :high_sierra
    sha256 "473aa4be5b23e7913f8dee39da5dbbbdbcabb747e63a29c9c241a5bca554f178" => :sierra
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
