class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "http://dvdauthor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.1/dvdauthor-0.7.1.tar.gz"
  sha256 "501fb11b09c6eb9c5a229dcb400bd81e408cc78d34eab6749970685023c51fe9"
  revision 1

  bottle do
    cellar :any
    sha256 "bd87b4f4e8c33a7a8275ea3b34c8e995f58b61d71a8a7b726d35639868b447c9" => :sierra
    sha256 "f295c54bd810948d3acf3223d7132c036acd9842a4c7fc449ac111f5e6971d9f" => :el_capitan
    sha256 "e91dd3ffd68dd00a08d6c2f72e395dbd95c83a2057ebe19bf0310d1abba4fa04" => :mavericks
  end

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkg-config" => :build
  depends_on "libdvdread"
  depends_on "freetype"
  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make", "install"
  end
end
