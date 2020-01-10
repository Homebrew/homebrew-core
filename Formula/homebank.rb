class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.3.tar.gz"
  sha256 "2b4c2838e433124433a4cbe241cc60ed2c2a2b061932330d797050ca0b559964"

  bottle do
    sha256 "4db7d01578a8588f38d2f481830e662b11039bde595c9958e51839d5a4471360" => :catalina
    sha256 "f6f16efea946ceac7d430f3aef7177454c11b759cc64433ef140b3e209dbb8b7" => :mojave
    sha256 "4ea21bb9617242f762aee8f92d152b21408c8908a4a7f1e0c7a79fb83bfd6888" => :high_sierra
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
