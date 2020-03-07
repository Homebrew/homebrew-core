class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.1/easyrpg-player-0.6.1.tar.xz"
  sha256 "2deb4c82301af943f076982e4685fcbaf4db53f3a32c265fa4bbc61cac730e64"

  bottle do
    cellar :any
    sha256 "83f79e7c021e82a781d50f3d7f731a2a4fbafc3dd166c5bdb2941859331982e4" => :mojave
    sha256 "75e146b0e863c2638c34e4d97affc301638cb6b041cf1b4a05aac1e93c7eead7" => :high_sierra
    sha256 "02aa23e4c5834569bf4b9c2dd5c38d5e557b9730a8fb78da4a382d9d90df41d4" => :sierra
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
