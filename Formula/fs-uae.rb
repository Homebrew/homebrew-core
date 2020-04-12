class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.3/fs-uae-3.0.3.tar.gz"
  sha256 "584260164641a977a82d37ffc6654031559be785a490237d25552d00b445ac6c"

  bottle do
    cellar :any
    sha256 "2cb4662c10c986ade12705af57c7e22a00fdd9d7a9614cc3ebbe0eca9b894993" => :catalina
    sha256 "ca6060bdc8914aaf5978987d337f07351c34411939f68d136262f63a7bfe6436" => :mojave
    sha256 "5563ad8f239034acb4ba21144f50ec62fa90982b576f4460bf3d57158afa1281" => :high_sierra
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
