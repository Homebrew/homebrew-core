class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.2.tar.gz"
  sha256 "920a305de2190665e127dad39676055d4d7cdcc5c546cbd232048b87eacee50d"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "70fc4328bb60338a6349988dac687b79a43f4265e8020406d0d9561b9d9f4858" => :high_sierra
    sha256 "cc55c80a8c35ee9ccae73317ec00c00ed35b71e264f725bc771d4a969b1394c3" => :sierra
    sha256 "9081895a4f8301e559fa4835718796c1f30ba5c2977fd18f83aab50421650c51" => :el_capitan
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
