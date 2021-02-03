class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 2
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a3b4f8442a0506243b3deda1b387132c9824def48e0f39d9af7a50c68bd5d4a4"
    sha256 cellar: :any, big_sur:       "dbf7cd6604b78dcf082303f1c5ec3fd28416525d11deb01531a783be34b8cb09"
    sha256 cellar: :any, catalina:      "bcb1f67978c8029a19e00d4332cf937dfd934306fd5d7446075f2bb888f4f78d"
    sha256 cellar: :any, mojave:        "c233ef4784c19621962b361b36afbbe82b8a929c7af3cbe609702e7776de28dd"
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
