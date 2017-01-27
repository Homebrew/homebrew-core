class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.51.tar.gz"
  sha256 "15a99792965d933a4936e48b671c039657546bdec6a318c223ab1131624403d1"

  bottle do
    cellar :any
    sha256 "84e26e4ae534c17cf53eb27f611990d565cf5f942001e131ed9204570cf3c371" => :sierra
    sha256 "3ae937491777d69408c0062cb7e21e2231037d7e8b3036c6bf0f0e6c83f070ad" => :el_capitan
    sha256 "06f31b3d710dde932f37b8d24b45791a04cfa3767bee288a03ee31587a156980" => :yosemite
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
