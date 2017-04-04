class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.0.tar.bz2"
  sha256 "e89ac39808e2bb1e17e031191af8ab7bdbe3d2b0aeca4c6040e6fc8761ec0240"

  bottle do
    sha256 "19f87788d761a5bc9a8ebd8c5efbd043dbb21f7c3eaaaf38b0bc015b51b5c284" => :sierra
    sha256 "a83f537c9410ff1253b770e75bd3ffef3131238d3d4c541dbdc77092726ceee4" => :el_capitan
    sha256 "96ff4f275637ccee0fb9949d0d1e29345b2105c5e26e12a5ae85d31c13051241" => :yosemite
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
