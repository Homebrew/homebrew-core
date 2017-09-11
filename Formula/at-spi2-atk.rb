class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.0.tar.xz"
  sha256 "d25e528e1406a10c7d9b675aa15e638bcbf0a122ca3681f655a30cce83272fb9"

  bottle do
    cellar :any
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
