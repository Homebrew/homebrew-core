class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.29.tar.xz"
  sha256 "ef68a9b67172383ea80ee46579015109433fa058728812d2b0ebede660d85f12"

  bottle do
    sha256 "c3c7f8c6425c97cff94a2e4c4d243ca1a93eb290e25f9ecc0648f829b6eb2a28" => :high_sierra
    sha256 "22f03b525346f87611fde7c3f22d02a68c133a835f27e17b5003f16a4d35da3a" => :sierra
    sha256 "ec4647fad45693bfa29ce801da1c8801b567b3987829aca96cdb1b71db12cfa1" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    # Fix undefined symbols _COLORS, _COLS, etc.
    # Reported 21 Sep 2017 https://github.com/MusicPlayerDaemon/ncmpc/issues/6
    (buildpath/"ncurses.pc").write <<~EOS
      Name: ncurses
      Description: ncurses
      Version: 5.4
      Libs: -L/usr/lib -lncurses
      Cflags: -I#{MacOS.sdk_path}/usr/include
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
