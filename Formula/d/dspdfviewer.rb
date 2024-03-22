class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 20
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f83c97434fb1113f3270923e1d9580dbc8bc6911abc5eaf2a87a47af47009a5e"
    sha256 cellar: :any,                 arm64_ventura:  "a3454aab434672e7bc009f2c71c5408e5663b35a35c3bd2e87c73c490bddd283"
    sha256 cellar: :any,                 arm64_monterey: "82fe18a01bb11af58548ba324274e7711cf99dc7163531b75b6cf9130df3f983"
    sha256 cellar: :any,                 sonoma:         "1ba6379a76d284404d66687d4c20a2594936433cf74eb9b0cd5c23884ad784a1"
    sha256 cellar: :any,                 ventura:        "853c10db87810d0f047c7f0dcc0d8253ff8b89da65ea790b8fed016278d5158f"
    sha256 cellar: :any,                 monterey:       "053bddda6226cf691399264e21cef2f01439456bbfedcbd3c76dd16153905030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f1f0fd930987f14206c82c5ea58f949be442005cb11f93aa9ab5c1a603b841"
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
