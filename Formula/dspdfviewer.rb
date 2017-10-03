class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 4

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "3e0bcd4579aec31375b4b985c8059acad58bc97ca7eee282ca0b889bbc4d92fd" => :sierra
    sha256 "972bdd66398993127bbfcd4b9239040c284bc78a46074d0b678b0675db8dc69d" => :el_capitan
    sha256 "bcf524ef5d8e4f801321003b7480384a4397dc34143c2632b6a4171a1aba6512" => :yosemite
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
