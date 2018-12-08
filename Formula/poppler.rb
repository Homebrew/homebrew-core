class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.72.0.tar.xz"
  sha256 "c1747eb8f26e9e753c4001ed951db2896edc1021b6d0f547a0bd2a27c30ada51"
  head "https://anongit.freedesktop.org/git/poppler/poppler.git"

  bottle do
    sha256 "0ec68e256f14f005279279b5b6bbd3fa7b6127e567072eab2948a028df0d36d7" => :mojave
    sha256 "dcac471ce08221a99ddf8aebfde60281ef170bbc5edf0ffd41f146e2de89250b" => :high_sierra
    sha256 "1321cf5f90a60eb65e407e766b08f91307a9e579dac2ed91998fb4fdfd30bac5" => :sierra
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
