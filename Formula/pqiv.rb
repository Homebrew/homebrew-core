class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.2.tar.gz"
  sha256 "920a305de2190665e127dad39676055d4d7cdcc5c546cbd232048b87eacee50d"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "13281416fdaab777ae5916d89eb56cee84924e968b7e16f41fdb16aca7822945" => :high_sierra
    sha256 "032562d45f4e1adf14aef733377e6da187266b29cd43829822d0a14bdf34bf41" => :sierra
    sha256 "5709bce082c1cc02a0c71c4e98d2f6840e6d752fcc23e51cbc73fcdbe2af8680" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "webp" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
