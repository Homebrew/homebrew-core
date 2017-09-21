class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.28.tar.xz"
  sha256 "f66e5b6fef83bdfda3b3efaf3fbad6a4d8c47bb1b3b6810bed44d3e35b007804"

  bottle do
    sha256 "31af467381a348580ef78519ec1eb63fd2c862b8964562a4a623af27319dc7a8" => :sierra
    sha256 "9849997446693fcfe6a9cdfc9c569e4fde7db6376b8ff159024c9b1b0bdd9a30" => :el_capitan
    sha256 "63e019d248f1060ac1f346ce2b32813420bdb1b343edaf85499f1453a8fb8c36" => :yosemite
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
    (buildpath/"ncurses.pc").write <<-EOS.undent
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
