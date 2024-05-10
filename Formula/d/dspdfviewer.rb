class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 21
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79c29bb5b00d42ec875ac7eeee654f2c5dfeefeafe087111c4c919d7970ced6d"
    sha256 cellar: :any,                 arm64_ventura:  "54a4cd401237db70f6430055fb2e133ada23da1fef164c6ff8cd1c9de050b6fb"
    sha256 cellar: :any,                 arm64_monterey: "dbb2d50f1735a532acfacecbdaf82cadcd03a90f29cea56f97af74d8d23d83b0"
    sha256 cellar: :any,                 sonoma:         "8edb8d291d0ce1c83fa4fff2284d60fee4d95bb5c8d523a2f4cb30f1889cea1f"
    sha256 cellar: :any,                 ventura:        "08bcd99f0ba33863ed96178da09edde14a5830c212936e47cb1b2664a3f29952"
    sha256 cellar: :any,                 monterey:       "6385603513ea82c1443c169623ae724efd3980b058b07c4c2397a23d62f82845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4985d5fc2d3162478d650974e8433513539178480bcf35dc0ab17b87a0e3a14e"
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
