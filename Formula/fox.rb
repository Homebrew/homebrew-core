class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.54.tar.gz"
  sha256 "960f16a8a69d41468f841039e83c2f58f3cb32622fc283a69f20381abb355219"

  bottle do
    cellar :any
    sha256 "735e60cd429680c3b8f916bbb83f7c136feda4ce37c4f61c80766c695d477f73" => :sierra
    sha256 "c5b0074d80dbc0e39e6f1adfefc3890276e40a26abc196b0961dda30b18e8f7e" => :el_capitan
    sha256 "b48658df4242bc972a47238d0885463399b220c46067ea34033f024197469728" => :yosemite
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
