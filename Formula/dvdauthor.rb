class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"
  revision 2

  bottle do
    cellar :any
    sha256 "b28cf71e6dec0467f9e87a1a1b4af0d06eb616f5748eadf52979d9e3fdf12c95" => :catalina
    sha256 "dd1e5474d6c92c842a0314b1359942f0e300902691babbf654750715dda95325" => :mojave
    sha256 "8ae1553ccb62320baa2aebc1bab814def0b96f7efeaa47743bcce80c7a65aed8" => :high_sierra
  end

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libdvdread"
  depends_on "libpng"
  depends_on "libxml2" if MacOS.version <= :el_capitan

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize # Install isn't parallel-safe
    system "make", "install"
  end

  test do
    assert_match "VOBFILE", shell_output("#{bin}/dvdauthor --help 2>&1", 1)
  end
end
