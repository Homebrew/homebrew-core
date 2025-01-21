class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 23
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2bface45d5755709da64d7ca8ad1cd83084184873fd0df4ac70208e6e4637c0"
    sha256 cellar: :any,                 arm64_sonoma:  "2b9f3cfb2c67e76fd58d45e22676e83d21d6fef080be544150052d03b26e4ded"
    sha256 cellar: :any,                 arm64_ventura: "12a58b62a7e2835817acdc79d1a894d365c542be1c8b4568896458532cb6555f"
    sha256 cellar: :any,                 sonoma:        "941a8f9f9d150cf65c1df615544975d88149cf358abb7f5fd62211430bfbf63d"
    sha256 cellar: :any,                 ventura:       "c4eac68c959c1a14d31c5a2977a9c15d24bca1c5bab169f61196ac0336e7b434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91de3a769d25fc70db8460cb2d6636eca33834a955364f4ec747fbe2a2efbfbd"
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

    args = %w[
      -DRunDualScreenTests=OFF
      -DUsePrerenderedPDF=ON
      -DUseQtFive=ON
      -DCMAKE_CXX_STANDARD=14
      -DCMAKE_CXX_FLAGS=-Wno-deprecated-declaration
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
