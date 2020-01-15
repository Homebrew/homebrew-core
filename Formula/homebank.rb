class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.3.tar.gz"
  sha256 "2b4c2838e433124433a4cbe241cc60ed2c2a2b061932330d797050ca0b559964"

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
