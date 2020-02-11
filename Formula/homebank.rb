class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.3.2.tar.gz"
  sha256 "4bc8b801582fe1cdaa412d2179d7141ee5edaa8bfbfa8692579151ec810124bb"

  bottle do
    sha256 "ba20973661fb121d4d69d744a07fb39e6c517ca9f638b73ebf84c140038dca92" => :catalina
    sha256 "64412b2979d77c7c0b5c7411ab5e18251ef7df292a8eee98aefc120f4acc17de" => :mojave
    sha256 "7c195f87d78a0aa550a3242e1a6c643bd92ead041d7a9c598a2683ef9bc00daa" => :high_sierra
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
