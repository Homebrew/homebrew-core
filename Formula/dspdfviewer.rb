class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 15
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5608e07059285b8fa01a4ef9da50bfabc88d45daa892440ca1d6964034005c54"
    sha256 cellar: :any,                 arm64_big_sur:  "4b1da827d7fd1b37568563024d6de2cec601a61273870c07caab6e198f4d1275"
    sha256 cellar: :any,                 monterey:       "e5cfd303e5e674878ccc916255b2badb33fb5affa3144df5e0f340afa27b77fb"
    sha256 cellar: :any,                 big_sur:        "049556ce9aba7d17efc8c11ca533a171efedadcf534b03303ada5ed8c76ef66a"
    sha256 cellar: :any,                 catalina:       "a1ca2f5a517c2a798990ef0f19671c9714e932afd2066c9b11a0ee39f577c072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4176a31204b3cc43a8aa1ffb4b3e7ead429165ec4139c25d4071e1dcbb604a"
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
