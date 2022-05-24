class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 12
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da24ba97fbae24b36492e878571a4a1cf07cf7979ded00ccc07c23f86e26ce1c"
    sha256 cellar: :any,                 arm64_big_sur:  "8b5db6a6870b1e825274f0a28a1f41da06e7325d45b21e700f2de94c59cf7e72"
    sha256 cellar: :any,                 monterey:       "26f5ad626166f23fe820ea41ded7cb9c3ab328178ee3f9d0eb5319fe02819f16"
    sha256 cellar: :any,                 big_sur:        "9a7b4b3ada6b75e933a8d577f9dc67e86eed733f5eab383ebe59dbf8c6fb2cd8"
    sha256 cellar: :any,                 catalina:       "de51c0869902887ee1f385d68358a04414bd85adea00aa481e1310a417e0749d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faeff34b7271731f882d46087c907b565b5218c77a6b57eba2227fb477cf42ab"
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
