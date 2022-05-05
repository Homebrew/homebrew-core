class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.05.0.tar.xz"
  sha256 "a969ced458e050d6202367bd7427054e2bd19bae39e8f969910d3b9151abf958"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f87bb640d0d99fe4f7e9bd86f5ff09ecda544380cb6c93665dfe7487066784b7"
    sha256 arm64_big_sur:  "84d29335c0f197a224b83d59c725a9383d5e5fc44182d26e86676f9b652a79fe"
    sha256 monterey:       "76a79f78a10d5c6247cd5dc3fce512181f4a69c0c434ade6cb9d81e36667bf2a"
    sha256 big_sur:        "f22d08bd557c6653d139ba2359ca575452ee6ce8d3069244f6a24d99a5522aa2"
    sha256 catalina:       "7bc5d7aa838edadfe709b65aeb41578bf9fd5bcad5f4711729eecbf56a726c70"
    sha256 x86_64_linux:   "d74dfcd6e1ea9532a26f5ef77c2aade97afb1cd5fc3e757edd78a9757afe161f"
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
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=OFF
      -DENABLE_QT6=ON
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

    if OS.mac?
      libpoppler = (lib/"libpoppler.dylib").readlink
      [
        "#{lib}/libpoppler-cpp.dylib",
        "#{lib}/libpoppler-glib.dylib",
        "#{lib}/libpoppler-qt#{Formula["qt"].version.major}.dylib",
        *Dir["#{bin}/*"],
      ].each do |f|
        macho = MachO.open(f)
        macho.change_dylib("@rpath/#{libpoppler}", "#{opt_lib}/#{libpoppler}")
        macho.write!
      end
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
