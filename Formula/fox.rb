class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.53.tar.gz"
  sha256 "1fe3d53691dad766f91e288fc7ec0f10ae735127766ed17298c3519591d83806"

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
