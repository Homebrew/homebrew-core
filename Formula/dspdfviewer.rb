class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 8
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    sha256 "f6063bf108432e891c5ec13665cde11d30498e99cf4d130236b78ea3a894c32c" => :mojave
    sha256 "93406709c843244b5c55b9f6167d67290899ac1aaa32bd32faa530fab66daae9" => :high_sierra
    sha256 "ec6ea81aaa5e037a27803b830a6bb8c7100b003a0095dec2dd3b1e217d1a6a30" => :sierra
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
  depends_on "qt"

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
