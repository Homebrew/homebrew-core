class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.12.0.tar.xz"
  sha256 "d9aa9cacdfbd0f8e98fc2b3bb008e645597ed480685757c3e7bc74b4278d15c0"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ff30dc71068cdf540a3cd25069aebf3ccdcd20a1e759b12ff0833cbe1912076f"
    sha256 arm64_monterey: "2b7097ac988058bb0215ca05f06ac9ef8738af6ebedfedc29cb1614b17b9fecf"
    sha256 arm64_big_sur:  "5089ad95740841275a4f6580fe1a9ec5fc2ecc25dd853624eb8c008ffe431420"
    sha256 ventura:        "534a4ef54ceec4fbcf9efbfb850167059d18ad64f67c7dd1022faa2a945c7ae0"
    sha256 monterey:       "5cdd5683ea933739fd6cec7723ad7568005c238f8a9f838ef1234da5a40e451f"
    sha256 big_sur:        "06c62a5a3d3302dfcca23b193a7810b45f6c6f091741a54f4f6ff6da176162ea"
    sha256 catalina:       "1149cb0f7d16c3f55a771bb1effa512eb783c0ed16b892d6603f847d64e8d88b"
    sha256 x86_64_linux:   "1abe4e5b95b5cf0b9e47d2ab797bd4214173175ef795c6592156ab3537ed45a1"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl", since: :catalina # 7.55.0 required by poppler
  uses_from_macos "zlib"

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
  end

  def install
    ENV.cxx11

    # removes /usr/include from CFLAGS (not clear why)
    ENV["PKG_CONFIG_SYSTEM_INCLUDE_PATH"] = "/usr/include" if MacOS.version < :mojave

    args = std_cmake_args + %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=OFF
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build_shared", *args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/libpoppler.a"
    lib.install "build_static/cpp/libpoppler-cpp.a"
    lib.install "build_static/glib/libpoppler-glib.a"

    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system bin/"pdfinfo", test_fixtures("test.pdf")
  end
end
