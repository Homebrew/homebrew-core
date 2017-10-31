class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.1.tar.xz"
  sha256 "b4f0c27b61dbffba7a5b5ba2ff88c8cee10ff8dac774fa5b79ce906853623b75"

  bottle do
    cellar :any
    sha256 "32913be917985716dfce85b54e9da03fabee252398628ef966e417895262aafc" => :high_sierra
    sha256 "bce618ed2d62539a8a657092f69ee12033ee45db9074c51f370fd89d73ef63fb" => :sierra
    sha256 "e3d340e6bc5093990778a09b1330f8ba375434e67eb880c8062782d7a9aa1947" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
