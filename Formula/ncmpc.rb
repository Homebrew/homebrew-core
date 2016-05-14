class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://mpd.wikia.com/wiki/Client:Ncmpc"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.24.tar.gz"
  sha256 "1e995c3d1ba20fd235dcb319e16a244c04c52c0792564b2091487035827eeb7a"

  bottle do
    sha256 "83911b3c3d4bb8c91a3f2e436882dced0e7b8a7733449f2ac2cfc0b6bc3512d2" => :el_capitan
    sha256 "5f97cdc0113766019222a32c3fd169d61d8fcb3bee1c613afa4a829604db13ff" => :yosemite
    sha256 "26830f339ba2ff11f2f5c5a0c56e4e108849dd4522b9b66cb74629a20f37ef49" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
