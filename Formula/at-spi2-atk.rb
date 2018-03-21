class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.1.tar.xz"
  sha256 "b4f0c27b61dbffba7a5b5ba2ff88c8cee10ff8dac774fa5b79ce906853623b75"
  revision 1

  bottle do
    cellar :any
    sha256 "55378269fb96de1448cb89ab226da2138503b713875d6ce009b455a52e1b3023" => :high_sierra
    sha256 "6d815c2cf4ffc7881f884e3a9b80771a3150a1c43aecb56fdf8b7f94e4bc17e8" => :sierra
    sha256 "574185424627a2c24041e448c77df13f57e614b08ff74371d29e6177557ba938" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
