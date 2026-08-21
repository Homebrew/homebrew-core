class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 27
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7b9d8549baa17f6f2f8ad9cc797c06e65a53107dc548fbc21ce628ba6f16f7b0"
    sha256 cellar: :any, arm64_sequoia: "46fc2736a9cf97d2da1ac0fd6601bb7b42dac5cc4958d61178d4bc0a232fb10c"
    sha256 cellar: :any, arm64_sonoma:  "41c70d79b1ef1c4fe3da1bd6bebe146a68bc65f216b9d0aab92d743d7638d8a6"
    sha256 cellar: :any, sonoma:        "7006f8059fa870d30aa023e71344554e8ccf1181efa10fcff8b9d7ee1fb4fa82"
    sha256 cellar: :any, arm64_linux:   "3e04e5be5c5812847aef667280e1bb889ff98ce5834f69caa62fb8fdb10a251a"
    sha256 cellar: :any, x86_64_linux:  "98cfc06501472d6861e2934517c643f717d5b7bb31cdef357d5ac7b4bc99f2e9"
  end

  # Last release on 2016-09-13, last commit on 2023-04-27.
  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"
  disable! date: "2027-05-19", because: "needs end-of-life Qt 5"

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
  depends_on "qt@5" # https://github.com/dannyedel/dspdfviewer/issues/236

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
