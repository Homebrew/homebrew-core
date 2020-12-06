class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-20.12.1.tar.xz"
  sha256 "d0aa2586c0a4296c775f0d2045f28bb95a694113fc995f95350faa12930f7b35"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "43c62d655b06eff1848328b02eff7767ab225f78e4de61c72663581bb316d327" => :big_sur
    sha256 "d89f6b867a6f012f44886b157f35f33179c583af93ace39329e7b62d2482eb31" => :catalina
    sha256 "82aef6a8cbbb04adb24d95a8069bfd042f7afed4de2caa7b55990d2f5c35f8db" => :mojave
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

  on_linux do
    depends_on "gperf"
  end

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.10.tar.gz"
    sha256 "6e2fcef66ec8c44625f94292ccf8af9f1d918b410d5aa69c274ce67387967b30"
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
