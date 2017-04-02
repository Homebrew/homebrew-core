class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"

  stable do
    url "https://fs-uae.net/stable/2.8.1u3/fs-uae-2.8.1u3.tar.gz"
    version "2.8.1u3"
    sha256 "7cc84844a77853f4fe2f2fc7da20ce94adc1a0c0c4b982ea28852a60b8a4d83a"
  end

  bottle do
    cellar :any
    sha256 "b8a7a49c89a089faeadd80528340fc6a2784d42daae3dc49bdc8afa09f941abc" => :sierra
    sha256 "fdb868e8219e71ecebb758e98637e75b133407f9525ceded636cf40b6fbe321e" => :el_capitan
    sha256 "56eff5b199b5aa079d71fb407eb141a2cd15fe03dcaa7d43febac676f0b7b898" => :yosemite
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
