class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.52/frotz-2.52.tar.bz2"
  sha256 "7e81789d7958ef42426a3067855cb3dc8eda04a5aa80d2803e32dd9282452932"
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "6917ea0ce2ce6b61e0bcf7a884a1617d74bebab7cb74a42b9013670f796a4fcc" => :catalina
    sha256 "8fb26f4a7b0e8d59f5002be8a83368dbb0ba04fd1818f9b0cb815b847c787558" => :mojave
    sha256 "d9abdc10abe135741446f19e2289606c69015f1142120dfb9be6863fe354b343" => :high_sierra
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

  resource("testdata") do
    url "https://gitlab.com/DavidGriffith/frotz/-/raw/master/src/test/etude/etude.z5"
    sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
  end

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc}]
    system "make", "all", *args
    ENV.deparallelize # install has race condition
    system "make", "install_all", *args
  end

  test do
    resource("testdata").stage do
      assert_match "TerpEtude", shell_output("echo \".\" | #{bin}/dfrotz etude.z5")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
