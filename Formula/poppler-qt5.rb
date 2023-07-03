class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.07.0.tar.xz"
  sha256 "f29b4b4bf47572611176454c8f21506d71d27eca5011a39aa44038b30b957db0"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_ventura:  "d202a705c9ed395970d1544f5aeedefe861f09b77bb960f54c4620af8d379068"
    sha256 arm64_monterey: "c2f78d5a23ba678f4b31bcc0e93d695c6aef6ab7ef47bf91bed683c69dd72948"
    sha256 arm64_big_sur:  "2b122d2f6c47b9d8f5b88cf7609da89fdc3b14aff17372552d40c34367cdf973"
    sha256 ventura:        "49848371fc39c62f4c8e554da712646cf48ae46358204736f8e132ecb2a63a36"
    sha256 monterey:       "69f8a93335a8d2f32e8c6b4371f6c673799465cc57ff5615df37d15922b244cf"
    sha256 big_sur:        "e443586af632adc3a108c87dec3cd63638303ef302e49bf7cab7cea22747f15b"
    sha256 x86_64_linux:   "8731cb47289bca1eca46656771c47b23a690db853082abf0e12ab61f603cc7d9"
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
    url "https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
    sha256 "c835b640a40ce357e1b83666aabd95edffa24ddddd49b8daff63adb851cdab74"
  end

  def install
    ENV.cxx11

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
