class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.5.1/imlib2-1.5.1.tar.bz2"
  sha256 "fa4e57452b8843f4a70f70fd435c746ae2ace813250f8c65f977db5d7914baae"

  bottle do
    sha256 "bf73b51f136932cbf6403da131f9e509eb05b6c677a42c1edcc82e5003d3e40e" => :mojave
    sha256 "7edcb670d36ba9a1ff093c23f08a87162e7ff0969591a5666ba4e7c42b91a047" => :high_sierra
    sha256 "2e9f97ed9f360067b209b424ef476282a12be3bea11cc30ef10b9848d7a754f8" => :sierra
    sha256 "90bd1801b3f7c1ada18b6a2982770453893c3f71b2fa07621e6a5c051e1776a9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :x11

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
