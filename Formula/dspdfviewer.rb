class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 1

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "fca362975f230719d3adcddf7b5b2f1d695936f5e76ef6db94ce2d58d939367f" => :sierra
    sha256 "71fb7892ca8cc6ae7cd30302f653127ec9b2e8d9c00d795029793a24bcde09bd" => :el_capitan
    sha256 "03c446c032abf21d2cede13917c45e61a4ae0c30ea9402a628e804686cc4f294" => :yosemite
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
