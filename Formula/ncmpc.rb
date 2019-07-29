class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.30.tar.xz"
  sha256 "e3fe0cb58b8a77f63fb1645c2f974b334f1614efdc834ec698ee7d861f1b12a3"
  revision 2

  bottle do
    sha256 "7b3d786665c467062935bd484d37fa1781364040a48d83c1da17759615a26bc7" => :mojave
    sha256 "5489be35a603c832514f87c7b1d1368a366abd133085968eb8f6eeaec8da08d4" => :high_sierra
    sha256 "1e7ecbd504ea76bb826e32221e1c8d90135969c785a7ee90e32db77d09ca151e" => :sierra
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
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

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
