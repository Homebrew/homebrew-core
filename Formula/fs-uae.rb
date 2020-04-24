class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.4/fs-uae-3.0.4.tar.gz"
  sha256 "86220bd2bf75ef1332b6948cd278b7f2e69586ed42c7989d034bc893658615b2"

  bottle do
    cellar :any
    sha256 "88d91491a023d41c76aa77ab76a09d14cb7f0bd4ac1b041973e47f2137337319" => :catalina
    sha256 "ffb967672718892546b62ec104c1740f9f618c7d8de6f65abaf077cd09f6426d" => :mojave
    sha256 "106759cc675ecfffd2aa08cfcc5068448ed53a080b168ee59679e720216e6cdc" => :high_sierra
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
