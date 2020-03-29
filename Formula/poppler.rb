class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.86.1.tar.xz"
  sha256 "af630a277c8e194c31339c5446241834aed6ed3d4b4dc7080311e51c66257f6c"
  revision 1
  head "https://anongit.freedesktop.org/git/poppler/poppler.git"

  bottle do
    sha256 "f1f4a95d8b5fe2b9b663e003eb5766953fb9ed053e50398d7adfc06e166239b0" => :catalina
    sha256 "ed48d79176e1b14827657f5761cad278080b54730debcd5020db8712cd08859d" => :mojave
    sha256 "3c092acf7818351a6234bfd640f6b343bef22ada2351c55bf9c49124ca86ddd2" => :high_sierra
  end

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
  depends_on "qt"

  uses_from_macos "curl"

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz"
    sha256 "1f9c7e7de9ecd0db6ab287349e31bf815ca108a5a175cf906a90163bdbe32012"
  end

  # Fixes crash issues in various downstream projects, such as pdfpc.
  # Remove with the next version.
  patch do
    url "https://gitlab.freedesktop.org/poppler/poppler/-/commit/68b6dd2ecd868c1a757cb8b9273e2e26687e5229.diff"
    sha256 "28dbc041981b2cb13d4fb18ce370496c4fa5c7c48bc688ffc10ae34c49c65349"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
    ]

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
    [
      "#{lib}/libpoppler-cpp.dylib",
      "#{lib}/libpoppler-glib.dylib",
      "#{lib}/libpoppler-qt5.dylib",
      *Dir["#{bin}/*"],
    ].each do |f|
      macho = MachO.open(f)
      macho.change_dylib("@rpath/#{libpoppler}", "#{lib}/#{libpoppler}")
      macho.write!
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
