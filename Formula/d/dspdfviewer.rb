class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 26
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ad754c8cc8521b9b1d0bc4b70539654a85d21825f8d7f9b3da942b3fe792e1b"
    sha256 cellar: :any,                 arm64_sequoia: "5f3e2fdaae9aee3810f4c23d4dd7cb0b13ba73573dd550aa719ac6e5bba46e97"
    sha256 cellar: :any,                 arm64_sonoma:  "9e4e4a152e4a95ee2c88af95de7bb0fd21e98d945977613bf359dc17aa1d049b"
    sha256 cellar: :any,                 sonoma:        "9cf13da6a32b08051b614bfe1ca5c46a44c4f8082461bb717f0c8df12621cd98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6916efa94ae9dde44f132bccaf1a7ba400e68c73f3975ed403719275dff24d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "634605018de8fd7ec5995d15f25fe2a622b1e78d89b74e77fba6f00a2e32b533"
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
