class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.1.tar.gz"
  sha256 "7fe1dd487bca1115e59d7668aeb4de32eb8ce1964f74d24ceb28694736597744"

  bottle do
    sha256 "26a0cc3cf6eb56cc5523e7a18395ff7c76f3dc69ca896df2947c82122db08e8e" => :mojave
    sha256 "1c66b7a0b56f88137724074fb6c663b4844e365c0dcad4dab2306cb4535ece9b" => :high_sierra
    sha256 "b5d0f629bf7edb08e966bab0661a15b6b621b5e28cfba415ddbafc1cfce77e84" => :sierra
    sha256 "8bda09727dabefac523464eaa6683bf067c35406aaad0ad730f3401c7b135b97" => :el_capitan
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
