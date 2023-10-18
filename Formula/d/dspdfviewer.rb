class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 17
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e6995d2892530eeda0375e99a3ff1112f86c149d9ec32f8747112abfd639fec"
    sha256 cellar: :any,                 arm64_ventura:  "0c72cae389342fa29a7bab30aff4e61bd8cd991e8dbe810076aec9040cd13b49"
    sha256 cellar: :any,                 arm64_monterey: "eb36dddf65861dcd008c48b9f519e8dbccc0be8cce76bc399d16b5fc37c673f6"
    sha256 cellar: :any,                 arm64_big_sur:  "113767585b61d4fe7d8f1525001194f71f9edfef3aa01fd24692ef1e5d21aa58"
    sha256 cellar: :any,                 sonoma:         "0f81a89bc2e2af2c05ce7de349e1b45a5e618b8ae7ec1c8238cdd04dd5b68264"
    sha256 cellar: :any,                 ventura:        "39e2c9e2a9078ec120477744c713d22351dc78685253f1ad885493ce679c8077"
    sha256 cellar: :any,                 monterey:       "732580c265f2c6c20534ebce228a7f2f874473015071748b2b54390b8babbbdf"
    sha256 cellar: :any,                 big_sur:        "389d8bc7e483440a56daf3b9b7681765689180799268a6774e3371dfdde7d876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07884b2723e104df33c4345e4a93aa37ab94c1ff95ecb41c3c7516ba667b30bc"
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
