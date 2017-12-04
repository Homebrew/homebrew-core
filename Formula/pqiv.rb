class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.1.tar.gz"
  sha256 "8f24ff072c17201703f68f139d31d82e239001b9612be4ad09c31e495372468d"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "08a7dc6945391c8415fe151a3e83ce5639d7d166b7c43eb14d18ecb8d51e211c" => :high_sierra
    sha256 "1045904350c88de71dff49a6352f2b4721026db7db83c4985875c6628cc860b5" => :sierra
    sha256 "864f702c0ea321245a093aac7916c561625087e5871a61faee3ab116e8041e31" => :el_capitan
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
