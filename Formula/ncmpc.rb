class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.27.tar.xz"
  sha256 "f9a26a3fc869cfdf0a16b0ea3e6512c2fe28a031bbc71b1d24a2bf0bbd3e15d9"
  revision 1

  bottle do
    sha256 "31af467381a348580ef78519ec1eb63fd2c862b8964562a4a623af27319dc7a8" => :sierra
    sha256 "9849997446693fcfe6a9cdfc9c569e4fde7db6376b8ff159024c9b1b0bdd9a30" => :el_capitan
    sha256 "63e019d248f1060ac1f346ce2b32813420bdb1b343edaf85499f1453a8fb8c36" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
