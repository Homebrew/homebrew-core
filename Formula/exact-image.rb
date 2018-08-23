class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-1.0.1.tar.bz2"
  sha256 "3bf45d21e653f6a4664147eb4ba29178295d530400d5e16a2ab19ac79f62b76c"

  bottle do
    sha256 "4a64b9a0321cce52f48a170fbb130e778c67443b5c772e818f458705a004284f" => :mojave
    sha256 "e93a0efc81c5850ed6aae96b412506f619c8a91551131267186f193259b1a730" => :high_sierra
    sha256 "785cbd24bf0673ea2d4870e328e0980dc147b558f91ac430ffe60a8224bf1c5d" => :sierra
    sha256 "4b5e274b9a97170371e21c26ef2ac783d498b2a8c92b34fd96d458e1ea10796b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libagg"
  depends_on "freetype" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bardecode"
  end
end
