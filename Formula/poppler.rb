class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  # NOTE: Keep this in sync with poppler-qt5
  url "https://poppler.freedesktop.org/poppler-21.10.0.tar.xz"
  sha256 "964b5b16290fbec3fae57c2a5bcdea49bb0736bd750c3a3711c47995c9efc394"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "aa3d848bb3583d7a0093e0c33ec6cbc447ea403cad8d3648f16c808e89e18289"
    sha256 big_sur:       "51941c9c044c59f9be78a7e3f219b6886ef54e86a1ed5221b718079eeca4eb9f"
    sha256 catalina:      "dc60de28ed20dad34cd77ac65fd92a00fe67d93dc4cb71613696a160df49f1ac"
    sha256 mojave:        "10d38d73fe15a2ef0554787c3b9f618c77a34d9a8fbaf57c730b8c1b17a8f40f"
    sha256 x86_64_linux:  "b0de9ccbd0178fb10bf59ce0345f7dde5806b1eecd01f3a066bccab806126db5"
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
