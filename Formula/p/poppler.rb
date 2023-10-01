class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.09.0.tar.xz"
  sha256 "80d1d44dd8bdf4ac1a47d56c5065075eb9991790974b1ed7d14b972acde88e55"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bdfba742a30ef1d6ca1c91d7dc2ed6ab779989a0525d198b3539589ad870f6e1"
    sha256 arm64_ventura:  "3b40f57034c434e364a83bd1b9249e7baae0f9a313ecce5b62f64a2a5da9e8f3"
    sha256 arm64_monterey: "2117ea0d320b580b33b012357f8e87d58b40fb7de225207e87c516d09f86946c"
    sha256 arm64_big_sur:  "6ff847a3f08990133ee7a4fac2cdf93c5ca34b5ad91b9ebf5e21e923487fca4d"
    sha256 sonoma:         "60b4fe9da0c385015f7afe6b8375f228b14941e842477e04b53dcaaa388fd857"
    sha256 ventura:        "ef04af03580586efb39c7cd2110d9031c5b5c43493c6efa422b3c5cfa909de05"
    sha256 monterey:       "b5e7d1270ee7e9804f75c5c6b87bb93339e48362ffe34564491de0e237b73bee"
    sha256 big_sur:        "19eea1ca42ec13c16d5738da2d249346da9a4d2b3b3e55eae603022160a7590d"
    sha256 x86_64_linux:   "c797aa04a47ff75e3d096914473f8afff8351219aa8bb35f0b2855eff685f933"
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
    url "https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
    sha256 "c835b640a40ce357e1b83666aabd95edffa24ddddd49b8daff63adb851cdab74"
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
