class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.71.0.tar.xz"
  sha256 "badbecd2dddf63352fd85ec08a9c2ed122fdadacf2a34fcb4cc227c4d01f2cf9"
  revision 1
  head "https://anongit.freedesktop.org/git/poppler/poppler.git"

  bottle do
    sha256 "306ad563af098497bd75f53d37ccdd2f0b8100fe1d8752310bcecf4f794760c5" => :mojave
    sha256 "eb8f157afeb8d6d55c4ec1bcead3cc70b62d9a19d091c425c5ea9aec18847aea" => :high_sierra
    sha256 "b8cff6d7773945250eab6a3e7174938b6d019c4907dc43b8b38a7fba343fd70c" => :sierra
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

    # fix gobject-introspection support
    # issue reported upstream as https://gitlab.freedesktop.org/poppler/poppler/issues/18
    # patch attached there does not work though...
    inreplace share/"gir-1.0/Poppler-0.18.gir", "@rpath", lib.to_s
    system "g-ir-compiler", "--output=#{lib}/girepository-1.0/Poppler-0.18.typelib", share/"gir-1.0/Poppler-0.18.gir"
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
