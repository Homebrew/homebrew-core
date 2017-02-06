class FsUae < Formula
  desc "Amiga emulator"
  homepage "http://fs-uae.net/"

  stable do
    url "https://fs-uae.net/stable/2.8.1u3/fs-uae-2.8.1u3.tar.gz"
    version "2.8.1u3"
    sha256 "7cc84844a77853f4fe2f2fc7da20ce94adc1a0c0c4b982ea28852a60b8a4d83a"
  end

  bottle do
    cellar :any
    sha256 "535474334ea992223e03eadeb76cee7d71c6cc9cb1da6ae586059a2381545116" => :sierra
    sha256 "7c419558f7db4581f17be1497384e583a1fe266cb6ef47007a977a254b957106" => :el_capitan
    sha256 "af020b1cddc577b937e0ce681e1572c134983e1e1eccf3d5ec1dc46394c11428" => :yosemite
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libpng"
  depends_on "libmpeg2"
  depends_on "glib"
  depends_on "gettext"
  depends_on "freetype"
  depends_on "glew"
  depends_on "openal-soft" if MacOS.version <= :mavericks

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unncessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
