class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily."
  homepage "http://www.fox-toolkit.org/"
  url "http://ftp.fox-toolkit.org/pub/fox-1.6.53.tar.gz"
  sha256 "1fe3d53691dad766f91e288fc7ec0f10ae735127766ed17298c3519591d83806"

  bottle do
    cellar :any
    sha256 "bf38e87fdaaff0091e1bee3eb028f6ab59d1c603ce36ab784ee87abc773ec035" => :sierra
    sha256 "634720097ef18967a41d9bc9d0071a16564bb77a4902dcd18dc178ed7d715442" => :el_capitan
    sha256 "f0f08e96b84fc836f1368a8d5cf85f747366259a1557031baf0d2bf4d165fbf1" => :yosemite
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
