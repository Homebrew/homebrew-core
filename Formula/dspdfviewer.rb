class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 5

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "18345b86cbf00c7239b1314153c77545e8a91917435f1171c55ee3f749a65c74" => :high_sierra
    sha256 "7c196c52c4ff0e5fabf5765d9123eee3d1ced53566d5709aebf98c0071ed99d6" => :sierra
    sha256 "9766cf4079d172bb80c91a561b0c762f0404c06391a3522177c3925b120e604e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "poppler" => "with-qt"
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DUsePrerenderedPDF=ON"
    args << "-DRunDualScreenTests=OFF"
    args << "-DUseQtFive=ON"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"dspdfviewer", "--help"
  end
end
