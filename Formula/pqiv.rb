class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.8.1.tar.gz"
  sha256 "ff8f28007535332f038c7d04a3c2d6696aa62604eef4fd66fc6500a8c235de30"
  head "https://github.com/phillipberndt/pqiv.git"

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
