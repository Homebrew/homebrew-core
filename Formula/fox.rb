class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://www.fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.56.tar.gz"
  sha256 "c517e5fcac0e6b78ca003cc167db4f79d89e230e5085334253e1d3f544586cb2"
  revision 1

  bottle do
    cellar :any
    sha256 "f709b5b4b8e58786b88b2b5a4c429a0ee5ff1dd242f09ab9e8b80b56407c45bb" => :high_sierra
    sha256 "b0c2a24b770bf69f1624d1bd25ca63f064165891d3a4c1cdd09be562b6848a69" => :sierra
    sha256 "db0892933de250a9d9487ddc62ed2ee7c3ad89c5ee87098f0aba6956869f8e5a" => :el_capitan
  end

  depends_on :x11
  depends_on "fontconfig"
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
