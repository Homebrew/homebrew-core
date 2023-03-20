class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 16
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ee081442cc15d6b6cb3c1c8791db4e1ac99caddf9e19b9a3e7da8f42c3fd6cd"
    sha256 cellar: :any,                 arm64_monterey: "1720055b7850161f0ff6b09a678d597b9357ae0bea2db05d2651f0c46d80197b"
    sha256 cellar: :any,                 arm64_big_sur:  "5d53db9ce37e910f71a0aaad82d1b26344d08decce5485751632cd05601f8c76"
    sha256 cellar: :any,                 ventura:        "834c422d0aa8a96cc77d1036e4793d3f8fdfdc79fcbf6c6a7da79f0c269459fe"
    sha256 cellar: :any,                 monterey:       "586e860f2c06b995132b35653a6c14403c012421cd9cf32baa1b379824e27015"
    sha256 cellar: :any,                 big_sur:        "0b551ba47aa6287fb0a94750a9ab85afa3e1d715d22d602dc98cdef34ac1b8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940e18745c5787e8ec2ce8a961283e44d148b45b4fc7370480057b6c15c3df6b"
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
