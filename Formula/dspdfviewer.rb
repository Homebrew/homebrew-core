class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.tar.gz"
  sha256 "19986053ac4a60e086a9edd78281f1e422a64efef29e3c6604386419e9420686"
  revision 1

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "5f23135aa30bf6fae45d453d892361daef51e19ffe510f5a9e79b5ed7393d0e3" => :el_capitan
    sha256 "69bf9e53d7b8fd5414f770baea119c7f22d1a05f752c7915cbe1f0cdc201a004" => :yosemite
    sha256 "d2f2ad9306d3417ab848ed98ca47481242a4a4064f8a8a1e1e6cc41aa286d4aa" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.61"
  depends_on "poppler" => "with-qt5"

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
    assert_match /#{version}/, shell_output("#{bin}/dspdfviewer --version", 0)
  end
end
