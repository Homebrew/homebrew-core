class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.71.0.tar.xz"
  sha256 "badbecd2dddf63352fd85ec08a9c2ed122fdadacf2a34fcb4cc227c4d01f2cf9"
  head "https://anongit.freedesktop.org/git/poppler/poppler.git"

  bottle do
    sha256 "b51232749ae49bb477e111173205a46f1d512dad19b151c7858323dfc9649e7e" => :mojave
    sha256 "f789f1bf9de71eb048b4b3fadc6b0193770bbb2847365f66de343e8e35335a78" => :high_sierra
    sha256 "c5cbefd4d56e775a00b83420b480a72968272d26186c84df7daf48821be43cae" => :sierra
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
