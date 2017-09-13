class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.54.tar.gz"
  sha256 "960f16a8a69d41468f841039e83c2f58f3cb32622fc283a69f20381abb355219"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2dfb7a62b9fda607fb7a11852b1123a7ba31fe4b381065da847a39e9d9ca589" => :sierra
    sha256 "1c723cdabbb6a784ed316ccdf810d41c36537adda7ccc1956b537e16a7adcdd1" => :el_capitan
    sha256 "671898e1a7fada8317a0d65c3606d1b2b91cbcb67c3b15a7adc9dc4a5d278d3f" => :yosemite
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
