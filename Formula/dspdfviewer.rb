class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 15
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00e271e02d46e1d1378e88ee1b332a6bb4bf9a36990ea0c7cb27a9650bc39f95"
    sha256 cellar: :any,                 arm64_big_sur:  "7421f2e247a714e2545c230c1d9b47e7908f44dc50d20de953e2ee545f86edfd"
    sha256 cellar: :any,                 monterey:       "f17cfd6dfdb3c63bef04a2fade88b46b9f0321937138e080d1255f30f17da6ef"
    sha256 cellar: :any,                 big_sur:        "a395d0fc80209d2f00e5b54d197442cb789c6aafb7b38ee96ed0ee685be5c5b6"
    sha256 cellar: :any,                 catalina:       "b44d2f06611d9f4e33b0af5ab2ea4f375445f2b92f67e484bb57029cfc053a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949d272617dea22608b31f67977f640aef4c804cf0039c8443b07934f7daa228"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "poppler-qt5"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DRunDualScreenTests=OFF",
                    "-DUsePrerenderedPDF=ON",
                    "-DUseQtFive=ON",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_FLAGS=-Wno-deprecated-declarations"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system "#{bin}/dspdfviewer", "--help"
  end
end
