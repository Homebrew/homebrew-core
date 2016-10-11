class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://mpd.wikia.com/wiki/Client:Ncmpc"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.25.tar.gz"
  sha256 "5b00237be90367aff98b2b70df88b6d6d4b566291d870053be106b137dcc0fd9"

  bottle do
    sha256 "2b0fe50a50ed2b67a05f58a0da2ab551a434621f5ecd449993a3898aea7aee51" => :sierra
    sha256 "2e02f6c2a5adbb5bf27f3b1c9dd33d1e77fed67d8599f83f2c3b65921c4731dd" => :el_capitan
    sha256 "a5ee00bd5006e9156199cd263cbd8ee6a5027b60f211017df0da14bb184b2cbb" => :yosemite
    sha256 "570fe6aba12ceeea5aea099879915a00a6459cd2f7c58e15248f4cc88c374b5a" => :mavericks
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
