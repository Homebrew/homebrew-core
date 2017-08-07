class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.54.tar.gz"
  sha256 "960f16a8a69d41468f841039e83c2f58f3cb32622fc283a69f20381abb355219"
  revision 1

  bottle do
    cellar :any
    sha256 "96ea42e219226d792fc14707a7b9c6a7a9eee10c54c3a77b5887c70cf095c582" => :sierra
    sha256 "559d99d28b45d719798e13bc05ed36017d4a25cb389fa57f0a0291b1e545855c" => :el_capitan
    sha256 "7e0a800668edebf6ad182f6bfd194a838f535bb662d82f8d431c28cf81238ed5" => :yosemite
  end

  depends_on :x11
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--with-opengl"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    rm bin/"Adie.stx"
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
