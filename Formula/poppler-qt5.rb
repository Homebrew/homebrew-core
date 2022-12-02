class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.12.0.tar.xz"
  sha256 "d9aa9cacdfbd0f8e98fc2b3bb008e645597ed480685757c3e7bc74b4278d15c0"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "1d5275f07fd5ad6485f4f214f63b2d3beaeaf2bdd56a0bee14864e002ee86bd1"
    sha256                               arm64_monterey: "45b6c11b08ff9a5062d3747655a7acae9f0ab2aa3452ec9fd8666fe6f6dd9ff2"
    sha256                               arm64_big_sur:  "d9b931a09b565905fb8a4aae101ff7bfdab61331dbfa9bd2ffc7d8d1c550e539"
    sha256                               ventura:        "759593a094a79793b0f68008c688f5b078ca76701109b32f43d87ad9ad00d0b1"
    sha256                               monterey:       "28460bbca33afdd26220227e2381940d8ddab1c8c8d3b7ddcc9cb9871a88d821"
    sha256                               big_sur:        "3f7993d818d06b99b4bdb645903456406d122e751109a3b6202ec0e13224f9f9"
    sha256                               catalina:       "b85866d008eccdb21aba389cb18e5bfc79f3cd992aac92531a923e99425f42ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0637063409bf9341a82f414def0b2ec637a111564a8d01ae10d1c4e72e57f560"
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
