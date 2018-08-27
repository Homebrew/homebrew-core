class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.30.tar.xz"
  sha256 "e3fe0cb58b8a77f63fb1645c2f974b334f1614efdc834ec698ee7d861f1b12a3"
  revision 1

  bottle do
    sha256 "98e442dd1d85222e8c38ab91bd5f1c578e8b4d52645431ffb3a564d2a2d1a42d" => :mojave
    sha256 "c9ed9273d7098162bb04e79d9d21b1fb35fdad6aadc2904c326f8aafb840caf4" => :high_sierra
    sha256 "b2782d26fd0dc87901d2d0f833a44bee7e702745e9a6b3601284411412b926dd" => :sierra
    sha256 "66ea4904dfb7452663a9fd694a6188ac278eb4d45e40e9af72aeb15209fe3f1d" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 800
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  fails_with :clang do
    build 800
    cause "error: no matching constructor for initialization of 'value_type'"
  end

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    # Fix undefined symbols _COLORS, _COLS, etc.
    # Reported 21 Sep 2017 https://github.com/MusicPlayerDaemon/ncmpc/issues/6
    (buildpath/"ncurses.pc").write <<~EOS
      Name: ncurses
      Description: ncurses
      Version: 5.4
      Libs: -L/usr/lib -lncurses
      Cflags: -I#{sdk}/usr/include
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
