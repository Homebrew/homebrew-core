class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.3.tar.gz"
  sha256 "6a64cc9a54e2b2dce9750797598995b54f430ea438455b474d2c83c69f41aff1"

  bottle do
    sha256 "98d95f2c3dbcc9807fa042eceb4e5847a9c7c1d80dda3cb9899cab4cd07a077c" => :mojave
    sha256 "45fb55769a347499b893a52fffa20227f1293265028bab62f01455da71cb6395" => :high_sierra
    sha256 "8dd722b5d8bd19c17b1419bc250f38033208109ada7742433c28b1471e4c1e7a" => :sierra
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
