class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.4.tar.gz"
  sha256 "58ddd18748e0b597aa126b7715f54f10b4ef54e7cd02cf64f7b83a23a6f5a14b"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "8b472820eabc7c3b28ac37b96be2a2054a9d83f7c162b55d220a6f6304e1a8ff" => :mojave
    sha256 "37e2305810ca1657383410f180cd5e6209e51f7b10569e7e9baea410c75ed12c" => :high_sierra
    sha256 "f7fa682d101cc54c677a7ecbbba92186f305f4ed420b81e74e040c9dccd1267d" => :sierra
    sha256 "c9d3102cc677cdfa8b9bb631621374ccde5e555d3468246494aa87a2875d5f1f" => :el_capitan
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
