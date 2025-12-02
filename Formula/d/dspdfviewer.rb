class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 25
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1abe6e8ef66106efcf70efa9fee70371adfad7a3d35ac39d2a0f86e34e827a2"
    sha256 cellar: :any,                 arm64_sequoia: "e8b8666c1dd37cbedb7baef9520a0f780f4414948c77dfffc155e2a3d4f1d007"
    sha256 cellar: :any,                 arm64_sonoma:  "1368c4d2b3c8f30845218d18990407f50447c80ad4d5d12468914649056cdb37"
    sha256 cellar: :any,                 arm64_ventura: "81fa4722ff6720d27cdf0e957db4ac26ace3098ecf9f930c9a62967e8b4cf8fc"
    sha256 cellar: :any,                 sonoma:        "45c98311e0f15c0e2a49aa93dd4d8d1099af2b003d973f9d7990e63fe8506f5e"
    sha256 cellar: :any,                 ventura:       "3ba36d9baaab63c71303b97c63aaf80de5a26771c1054d660d604f9ebdea7c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04a37539e5a626f8304d80a0ef7031b677f3bd779816152a5b9d15c1257053c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca5f6fc6b6b9ddbaa85c87107317aba3bf14fd5a9c0824460efeb612e34be2ae"
  end

  # Last release on 2016-09-13, last commit on 2023-04-27.
  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

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
