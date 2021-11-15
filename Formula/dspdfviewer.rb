class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 11
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d3d3383fcb214390beda2e696d2b01ffe97705352ac7486aeae9398f829fe832"
    sha256 cellar: :any,                 arm64_big_sur:  "906f49e56185764e6bd001cdf165d34a288449d2c7da470d7be578b63d736f59"
    sha256 cellar: :any,                 big_sur:        "af329c28bb3455247fdd2d3048d75fbbd0b685d97251c4c80acad5c3e1c30404"
    sha256 cellar: :any,                 catalina:       "afeebf5d866baa9e1c57005c44a359a5b5f409259a296765b4b9234eb80f96fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ea0adb9cfd4fa87f6c653bd8fc6c9b29820a8971e8e18f56a121d2e99e0501"
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "poppler-qt5"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DRunDualScreenTests=OFF",
                            "-DUsePrerenderedPDF=ON",
                            "-DUseQtFive=ON"
      system "make", "install"
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system "#{bin}/dspdfviewer", "--help"
  end
end
