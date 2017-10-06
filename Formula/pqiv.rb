class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.9.tar.gz"
  sha256 "e57298ae7123bd6b01b751f6ef2d7a7853e731a3271b50095683442a406da99c"
  revision 4
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "e08c27c49dafa0c46514cf8d560f546c453a6ad0cf7089b1ab17b972ca9d47bb" => :high_sierra
    sha256 "e81b0085b51f799438136b9c6e53747dfe8f97b753e0aeb6f73d6efe392448a0" => :sierra
    sha256 "a013b41a64e53ce9d2cf5308b738d8e465ecac21fb637b0af294d052cfdc6e26" => :el_capitan
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
