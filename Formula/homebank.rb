class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.2.tar.gz"
  sha256 "c6ce84b421e7199ae545ea8b8d981f347af4d67b4cd5912b6789cf1450db722e"

  bottle do
    sha256 "aa749fac81a7659dc5749076e2f6cdf585a06c2b8629ff65cbaa1527aeace397" => :catalina
    sha256 "d23f83f4aa1a034f41964d65681deb90966712f51bd635b19f2b461b5e0c7327" => :mojave
    sha256 "417184676c620e0f2ec3f2ea4cf41a834bf018f7478cb98c0b17e374d27f8f44" => :high_sierra
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
