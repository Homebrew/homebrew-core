class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 19
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a8817387a94f286a1b57e0a1b857c6f66f056931f31b3731229dbced6142211"
    sha256 cellar: :any,                 arm64_ventura:  "c705ac0013d512e4d0bee5e9dea57e44acf25345de90af557d017c01474d9a12"
    sha256 cellar: :any,                 arm64_monterey: "6ad7787545bd4cae8b87da331ea1ae9961a0ad1327efb6e8b02507567c894062"
    sha256 cellar: :any,                 sonoma:         "6e2520d416becedcf034593d56870a0ddf8ba38db1f7b1de40ef8b2afea48c59"
    sha256 cellar: :any,                 ventura:        "9f4187d0c5e0c55b41c32e2477c9ba2f8e0c95dddf1ddebce6555da83ff1e56c"
    sha256 cellar: :any,                 monterey:       "55891e79a2742d1552db6e5839d6164c50fcc29184765fb4550fb785f869a5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43654e97a188ef38cc0f10bbe620bb877e218866effabcf08dc896df00547adf"
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
