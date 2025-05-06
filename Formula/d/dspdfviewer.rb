class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 24
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e3e58ee1b8f07f27875503f799f27a43005828e3e952a7796ff3ba0e7348ed6"
    sha256 cellar: :any,                 arm64_sonoma:  "9d5d2f9eba46d09ca76df8877045f43cd5fe09c3f941be53db33a874e967451a"
    sha256 cellar: :any,                 arm64_ventura: "9a65187c3e58d232fb02d2036bbec56b844dc5a00efd0b4a057a489268d02e02"
    sha256 cellar: :any,                 sonoma:        "feca0534b99e6265c66b5fdf1f9949db4948003715a58c27755171b19659dd28"
    sha256 cellar: :any,                 ventura:       "9f34c4b625b6d91a6e2708217ea7f93677ead5810433a880e96f924a2258ae27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4719064766a35fa5c5879cd048d143732e7f54e8df986505ec00512e9cf1022"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "poppler-qt5"
  depends_on "qt@5"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Allow setting CMAKE_CXX_STANDARD in args
    inreplace "cmake/compiler_clang.cmake", 'add_definitions("-std=c++11")', ""
    inreplace "cmake/compiler_gnu_gcc.cmake", "add_definitions(-std=c++11)", ""
    inreplace "cmake/compiler_unknown.cmake", "add_definitions(-std=c++11)", ""

    args = %w[
      -DRunDualScreenTests=OFF
      -DUsePrerenderedPDF=ON
      -DUseQtFive=ON
      -DCMAKE_CXX_STANDARD=14
      -DCMAKE_CXX_FLAGS=-Wno-deprecated-declaration
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?

    system bin/"dspdfviewer", "--help"
  end
end
