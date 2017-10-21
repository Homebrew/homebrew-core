class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.28.tar.xz"
  sha256 "f66e5b6fef83bdfda3b3efaf3fbad6a4d8c47bb1b3b6810bed44d3e35b007804"

  bottle do
    sha256 "b5c63c88c01e38ffbe360c89cf2abff2be9bb74eefc05f2e1aca31d52abbf4fd" => :high_sierra
    sha256 "6b56075edd90d0e6b7b9e30a5606633c994091bdb22839bbf0626c405ebbe06c" => :sierra
    sha256 "c853f8a4110be0dbc3a4bdc82af29c1e85d64a5b6b05adce5cfe0734d1972f63" => :el_capitan
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
