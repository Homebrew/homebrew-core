class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.9.tar.gz"
  sha256 "e57298ae7123bd6b01b751f6ef2d7a7853e731a3271b50095683442a406da99c"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "c06abf7d27f7c92b652334a3d27e724c12ddc0f0fa10f26399ef7ccb83abb31b" => :sierra
    sha256 "cbdb2e8c4f6052552545a18c68331f92410a80844e7619881d794fb567b2a72c" => :el_capitan
    sha256 "41c7e46b6bd5363a3ac6e2faeb7335ee27e1673a76e2370a06a6e5922f88411d" => :yosemite
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
