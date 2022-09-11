class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.08.0.tar.xz"
  sha256 "b493328721402f25cb7523f9cdc2f7d7c59f45ad999bde75c63c90604db0f20b"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_monterey: "c481ab871309497b7def3619817adb617f8393a6d703fd5d8cb7c1b8f1cb3051"
    sha256                               arm64_big_sur:  "d3404b6ad8d590fc7c5764a9bf93cca7f1e80f7a72e0a14129071b69d9cfac80"
    sha256                               monterey:       "8d45b9235e5309828d7e79cd7fe4caa02e1af37e81b2c5f661b332befd9687e1"
    sha256                               big_sur:        "087d8042b57091f8c5c018ead30acb6c8328c4c9539fa43ee8dae7185caf926c"
    sha256                               catalina:       "46cb5c083625dd74c360bacc0b7e3ef2fe76f6f50d4b0f962fcf31a6fb443c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56622ae085758f3c2392315bacc466ba66ec6220e227cb92dc91dce2b4445164"
  end

  keg_only "it conflicts with poppler"

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
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
  end

  def install
    ENV.cxx11

    # Fix for BSD sed. Reported upstream at:
    # https://gitlab.freedesktop.org/poppler/poppler/-/issues/1290
    inreplace "CMakeLists.txt", "${SED} -i", "\\0 -e"

    args = std_cmake_args + %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
