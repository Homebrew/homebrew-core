class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.0/fs-uae-3.0.0.tar.gz"
  sha256 "221568b8f78bac352f84297f0cabe984d3da4f808e39cc3191541c02b389c964"

  bottle do
    cellar :any
    sha256 "99c0efd17141470c96e857a0e00696f2d0e6c901d7fa39a2efe30cf5112203ee" => :catalina
    sha256 "a520a09e6a703765acaf3829b901b86d6f6503ef2887f1c5495ba6f309443a23" => :mojave
    sha256 "ece2223f92dbe078b29dda91e691551d6788f8ea22fa7cc46919b125c4d62fb1" => :high_sierra
    sha256 "f4b193b58774d21e007cd83a564ee8d2efab0f99bb213d91424c56f472ae35ee" => :sierra
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "openal-soft" if MacOS.version == :mavericks
  depends_on "sdl2"

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
