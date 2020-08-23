class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"
  revision 2

  bottle do
    cellar :any
    sha256 "669b5fe5348ceb668f9ff55c4942c240f585eb5167e2dfbe1142442fcf7b776b" => :catalina
    sha256 "3e4e46c56905c289d31d167e75ee3b033a197fc0dda4b6b56dec752ac9773c51" => :mojave
    sha256 "55cee6a535eec67fc4f1ea65c2283d69c420d32933d9bcd6106168796ba1af9a" => :high_sierra
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
