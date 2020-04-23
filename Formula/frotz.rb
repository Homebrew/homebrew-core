class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.51/frotz-2.51.tar.gz"
  sha256 "7916f17061e845e4fa5047c841306c4be2614e9c941753f9739c5d39c7e9f05b"
  revision 1
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "db1857e58aa0186b418a41426a65ebc047bbda6ed3c29cd8d79ac9b52bde4823" => :catalina
    sha256 "b08e671b1146e1670a25e035b8c69cafc6d21d32700ef9e5e9c3ddaefa3b1ba7" => :mojave
    sha256 "c529875e350b14e50ff06777fca8b5455fe18f20a3ab9efc51929f5358a1d501" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libao"
  depends_on "libmodplug"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc}]
    system "make", "all", *args
    ENV.deparallelize # install has race condition
    system "make", "install_all", *args
  end

  test do
    assert_match "FROTZ", shell_output("#{bin}/frotz --version").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz --version").strip
    assert_match "FROTZ", shell_output("#{bin}/dfrotz --version").strip
  end
end
