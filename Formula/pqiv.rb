class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.8.3.tar.gz"
  sha256 "b90c45d829eb180459dcfbf1420b8feb670dc9bb542fe307adbc4ff201445bbd"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "23ee53fc6d98f8513490e3c0c495a288796b4efc637d1cefa00373e755a3415d" => :sierra
    sha256 "d09aa830367b7ca46b603f541580285f6daed7248e7c53cd00efe30494e09245" => :el_capitan
    sha256 "20cb3a3110160004be6489889c155b22eec9d845f08c3019707d1af47bad9f4f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # pqiv does not work at all unless a display is present
    # (it just outputs an GTK error message)
    system "#{bin}/pqiv 2>&1 | grep -qi gtk"
  end
end
