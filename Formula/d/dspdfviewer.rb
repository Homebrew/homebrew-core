class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 22
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ce3347f631f796c57c1fe421fd402cdd77df6c8bb245efeaf64eb6fb2c561363"
    sha256 cellar: :any,                 arm64_sonoma:   "5db996084e2c7e06c3c474933cb6e4255fa1c37dea5a111f82a971a8e2dfec73"
    sha256 cellar: :any,                 arm64_ventura:  "52596ae451143f2669614d9694c304c3123168d7db50d79bdcd12aa6684040d7"
    sha256 cellar: :any,                 arm64_monterey: "84ee197efe13c91f1f127e68796c2d77cb5d694dab0943b1b3372bede5158c68"
    sha256 cellar: :any,                 sonoma:         "4f23c224799ec83898e871f708bad7da8817b85d68580bbcf58c14b30cedb768"
    sha256 cellar: :any,                 ventura:        "06d12144f5919f8068177086a482988e116e88091e771c6e91918f0cd720f776"
    sha256 cellar: :any,                 monterey:       "efeeee0f226a452c50e0077ac08d82e8c588de102fbf41deff4c2047a6f098c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e95e14b53711e78ccd607afb0f44ba040f27b381d23cd4a7b6cec8ebb7d09ba"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build

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

  fails_with gcc: "5"

  def install
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
