class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/2.8.1u3/fs-uae-2.8.1u3.tar.gz"
  version "2.8.1u3"
  sha256 "7cc84844a77853f4fe2f2fc7da20ce94adc1a0c0c4b982ea28852a60b8a4d83a"
  revision 1

  bottle do
    cellar :any
    sha256 "e2c8c82746c1efe5d2205292b996fe314d40f40bab256178bd73d0dc79101d7a" => :sierra
    sha256 "02e668e32f69d3b5c36e6b3c0bfde146cfcbddfcfc0b8d0071bb8a992c0c4ba5" => :el_capitan
    sha256 "4643d884b880a4e4783f740b8411f0be8d0ffc649e4d1cde945954e17b642160" => :yosemite
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
