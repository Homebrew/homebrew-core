class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.3.1.tar.gz"
  sha256 "1bc286039f8b318b959f2faa7a1f06db432ed5181a51a287d2c88ec150f63485"

  bottle do
    sha256 "9d06bbdeb0ed0600aa5e13527e3636d1198a3c37fafb7038651155aaa388878a" => :catalina
    sha256 "c55784d03105a67b9e95e0d2e04071c3dc45a2ec6ac4f7ce73dd59f06eb9cd4a" => :mojave
    sha256 "9276df1fa7f820af547d760aa21624a57c1ff53e0b737d342af429f549bedc48" => :high_sierra
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
