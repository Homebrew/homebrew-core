class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.2.tar.gz"
  sha256 "acc8221fffbbe4b6ddc23fe845fa061cae2ecf7643f2ed858adc9a2e6e2295a5"

  bottle do
    sha256 "f8f1db3659b1a87ce1ff8d970b58248156a6ca9fb5d57fed560afdb3af9b780f" => :mojave
    sha256 "73a738ffdbc69b90ba8b4d6e2cd567d2d4667c3303c811fc9e37784f3c022194" => :high_sierra
    sha256 "150d6652d687822536b9482023ea85485b48eb546ee87ebc8a3248ceaa7e79e7" => :sierra
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
