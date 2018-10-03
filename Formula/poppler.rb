class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.69.0.tar.xz"
  sha256 "637ff943f805f304ff1da77ba2e7f1cbd675f474941fd8ae1e0fc01a5b45a3f9"
  revision 1
  head "https://anongit.freedesktop.org/git/poppler/poppler.git"

  bottle do
    sha256 "975b11cbafebf19b275438d153a37ac45808ac6756f3d00ba6a5522f69da48ee" => :mojave
    sha256 "8b8fcb486a81ec85c429d8747f0cb59629ffe1b63da54042b48e063a2344e872" => :high_sierra
    sha256 "ae42f96291d9149173137b1174f06efa7e89760ba2ed2cfb46176686c32ef7a9" => :sierra
  end

  option "with-qt", "Build Qt5 backend"

  deprecated_option "with-qt4" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt" => :optional

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz"
    sha256 "1f9c7e7de9ecd0db6ab287349e31bf815ca108a5a175cf906a90163bdbe32012"
  end

  needs :cxx11 if build.with?("qt") || MacOS.version < :mavericks

  def install
    ENV.cxx11 if build.with?("qt") || MacOS.version < :mavericks

    args = std_cmake_args + %w[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT4=OFF
      -DENABLE_XPDF_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
    ]

    if build.with? "qt"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DENABLE_QT5=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *args
    system "make"
    lib.install "libpoppler.a"
    lib.install "cpp/libpoppler-cpp.a"
    lib.install "glib/libpoppler-glib.a"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end

    libpoppler = (lib/"libpoppler.dylib").readlink
    to_fix = ["#{lib}/libpoppler-cpp.dylib", "#{lib}/libpoppler-glib.dylib",
              *Dir["#{bin}/*"]]
    to_fix << "#{lib}/libpoppler-qt5.dylib" if build.with?("qt")
    to_fix.each do |f|
      macho = MachO.open(f)
      macho.change_dylib("@rpath/#{libpoppler}", "#{lib}/#{libpoppler}")
      macho.write!
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
