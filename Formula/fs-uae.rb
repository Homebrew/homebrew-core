class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/2.8.3/fs-uae-2.8.3.tar.gz"
  sha256 "e2d5414d07c8bd5b740716471183bc5516bec0ae2989449c3026374dc4b86292"

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
