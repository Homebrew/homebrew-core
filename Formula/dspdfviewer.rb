class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 10
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256                               arm64_big_sur: "61b84a1c0fc1bcc6e011727e834386fb705bd1fc35b891bf8c05c53251760617"
    sha256                               big_sur:       "d96af2845578b66dcd24e9c365caf4b6dea54b3a017168f897ae7048f3837a6d"
    sha256                               catalina:      "484ae962819c03c55c83a6df14978c05962ed42f77044aae7a0717574cb5028a"
    sha256                               mojave:        "80db38b231f37116816d5889d9b934f332b011049b88007d316ab55c77eed061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45eb33e444426afe4c2770ce2db8d52aaa46955291e1ed3fea8e0ffb54744a26"
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
