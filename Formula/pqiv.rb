class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.2.tar.gz"
  sha256 "920a305de2190665e127dad39676055d4d7cdcc5c546cbd232048b87eacee50d"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "c30bb54634368223c328128c5e8d6f1e1b69fe2a7341b6efd4ba9a11de6426e9" => :high_sierra
    sha256 "3b7870df9a5890beb55a6e6bb0e4e4ace946027df1ce9b5cb7b56c53e8fa48f0" => :sierra
    sha256 "397af2c3c76c91af0f1dab28ef23beab813abfc363a1d0c34bee7a294e940d22" => :el_capitan
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
