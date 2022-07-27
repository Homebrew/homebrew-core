class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 14
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7788d23981291111aa70b4276cda1666c79f0a2ab9dbf8f577b2516c9cf80dfc"
    sha256 cellar: :any,                 arm64_big_sur:  "5d5200b766b74e0671d62eac73adb4a00f3cfb21df5d95c03db1e2e4c236a3e8"
    sha256 cellar: :any,                 monterey:       "bccef42244d0478806c367455d4b489dcc929e0883f6369738587281b2702ecb"
    sha256 cellar: :any,                 big_sur:        "ec7b52f46aef8402cd3759765f12437bcc76a9a64f6f98fc8c0851f7df6917da"
    sha256 cellar: :any,                 catalina:       "7ff20137a4d5d26f96a44c7431df9e138af7685f478bf8999c93cd675cc6250f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281efd582e6bab5e76d0817cda17f2cab472722ea6a3ecb27e0d78e7a47a35eb"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DRunDualScreenTests=OFF",
                    "-DUsePrerenderedPDF=ON",
                    "-DUseQtFive=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system "#{bin}/dspdfviewer", "--help"
  end
end
