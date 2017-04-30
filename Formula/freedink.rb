class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine."
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftpmirror.gnu.org/freedink/freedink-108.4.tar.gz"
  sha256 "82cfb2e019e78b6849395dc4750662b67087d14f406d004f6d9e39e96a0c8521"

  depends_on "check"
  depends_on "sdl2_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "gettext"
  depends_on "libzip"
  depends_on "fontconfig"
  depends_on "pkg-config" => :build
  depends_on "freedink-data"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  def post_install
    ln_s "#{HOMEBREW_PREFIX}/freedink-data/share/dink", "#{share}/dink"
  end

  test do
    FileTest.executable? "src/freedink"
  end
end
