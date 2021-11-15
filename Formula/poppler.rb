class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-21.11.0.tar.xz"
  sha256 "31b76b5cac0a48612fdd154c02d9eca01fd38fb8eaa77c1196840ecdeb53a584"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e3af44cb95961c1f4772cbe4716fd40c21f899729eb70639c2ef99e010a3874e"
    sha256 arm64_big_sur:  "0ea9f577570dbf1ccf82b9af5406c4b643eae9cf5b2fbe5390c23e48d8d1d104"
    sha256 monterey:       "4e4cf65dcbde0ea86a4f5e424ab004eda7cb188f9a441a41cd0c48b32de3cd18"
    sha256 big_sur:        "ad810755d806312b91a7e6a37be4618e093bdaf88e2ca2ea582ce46554f98909"
    sha256 catalina:       "3acd03d858df12c89b57021b461981094ce9c8881a0a43395c5fb06576dab0a6"
    sha256 x86_64_linux:   "990fbb77844f138d76390fb702eb3286de048a7585985e2f74b525ba9cd4bde9"
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
