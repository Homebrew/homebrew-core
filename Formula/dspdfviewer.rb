class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0"
  revision 9
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256 arm64_big_sur: "61b84a1c0fc1bcc6e011727e834386fb705bd1fc35b891bf8c05c53251760617"
    sha256 big_sur:       "d96af2845578b66dcd24e9c365caf4b6dea54b3a017168f897ae7048f3837a6d"
    sha256 catalina:      "484ae962819c03c55c83a6df14978c05962ed42f77044aae7a0717574cb5028a"
    sha256 mojave:        "80db38b231f37116816d5889d9b934f332b011049b88007d316ab55c77eed061"
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
  depends_on "qt@5"

  resource "poppler" do
    url "https://poppler.freedesktop.org/poppler-0.65.0.tar.xz"
    sha256 "89c8cf73f83efda78c5a9bd37c28f4593ad0e8a51556dbe39ed81e1ae2dd8f07"
  end

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz"
    sha256 "1f9c7e7de9ecd0db6ab287349e31bf815ca108a5a175cf906a90163bdbe32012"
  end

  def install
    ENV.cxx11

    resource("poppler").stage do
      system "cmake", ".", *std_cmake_args,
                           "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                           "-DBUILD_GTK_TESTS=OFF",
                           "-DENABLE_CMS=none",
                           "-DENABLE_GLIB=ON",
                           "-DENABLE_QT5=ON",
                           "-DWITH_GObjectIntrospection=ON",
                           "-DENABLE_XPDF_HEADERS=ON"
      system "make", "install"

      libpoppler = (libexec/"lib/libpoppler.dylib").readlink
      to_fix = ["#{libexec}/lib/libpoppler-cpp.dylib", "#{libexec}/lib/libpoppler-glib.dylib",
                "#{libexec}/lib/libpoppler-qt5.dylib", *Dir["#{libexec}/bin/*"]]

      to_fix.each do |f|
        macho = MachO.open(f)
        macho.change_dylib("@rpath/#{libpoppler}", "#{libexec}/lib/#{libpoppler}")
        macho.write!
      end

      resource("font-data").stage do
        system "make", "install", "prefix=#{libexec}"
      end
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DRunDualScreenTests=OFF",
                            "-DUsePrerenderedPDF=ON",
                            "-DUseQtFive=ON"
      system "make", "install"
    end

    libpoppler = (libexec/"lib/libpoppler-qt5.dylib").readlink
    macho = MachO.open(bin/"dspdfviewer")
    macho.change_dylib("@rpath/#{libpoppler}", "#{libexec}/lib/#{libpoppler}")
    macho.write!
  end

  test do
    system bin/"dspdfviewer", "--help"
  end
end
