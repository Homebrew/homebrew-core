class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2.3/easyrpg-player-0.6.2.3.tar.xz"
  sha256 "6702b78949b26aeb6d1e26dbffa33f6352ca14111774bfd433bc140c146087d0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    cellar :any
    sha256 "41e511a22bb391abf5eeadf943f5b15096247172fbd5903c5b655dbd37113067" => :catalina
    sha256 "f045884bc432cfb9d5f12d58511d9be9c963a3f9394f58213d12fb8640ab4fc3" => :mojave
    sha256 "4469eaf8e9a0e3c1761a35f33a1aee36fda74bd07752ad3245ef9f766fe9ffe7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "speexdsp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v")
  end
end
