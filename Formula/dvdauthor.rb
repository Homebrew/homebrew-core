class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"

  bottle do
    cellar :any
    sha256 "e7f18d7e9e16892ad5dacf7d5dd094016da3331a19f4c5b81e9b16f134b88fd3" => :mojave
    sha256 "c31cd13def25b19f42dc4472ebb7013069aea342d6da18de5b8aa4ce68ddecba" => :high_sierra
    sha256 "021c04387000c15dfd64763c9cf4eb7dd23ee0bed9e79941c8ff00182bf4e3b2" => :sierra
    sha256 "adeee0423ba54e77da2710f1877e0cbc43733f833abc73ad76465a7d34c829a7" => :el_capitan
    sha256 "b4c79aab01e4ae32f39107af7ef863fd75f75cf7d9e32731be3f2e2e4d49d782" => :yosemite
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
