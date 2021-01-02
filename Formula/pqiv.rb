class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "8b7446a8fdb4038fb33fa40212691349a0eb08288902c7dcf9ff84408e197ccb" => :big_sur
    sha256 "540f256f69b195097e0e1d6ce3f48df96c67e8dc7f78e2fa24fc48d628da15e2" => :arm64_big_sur
    sha256 "a11ce64393a216d1401678a5ffafc278dd452f61504c1fba0cb95326f3e4ef9e" => :catalina
    sha256 "7da5cf782806b1a1854cb0826f1d419f0be2a82a47d0a223fdc62cf2021ad66c" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
