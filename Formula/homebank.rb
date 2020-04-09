class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.tar.gz"
  sha256 "3110b079ecae7efbf46c0ae980029e6355ee320440b71b4c6f0c7e66f4cd9aa7"

  bottle do
    sha256 "a92a7cd724ca4056df6252b63727dc70833aa08bbfd63ca0d378fdd3ea2cf2f3" => :catalina
    sha256 "0dd390e7c9919002c228914c51b629b82660f6084e1e351555b11fc30d5d0546" => :mojave
    sha256 "3cb2234ec0bfe041e0a7c31f685c1b1fd9b7197acc60c957e248ab8ce54d7b81" => :high_sierra
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
