class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.08.0.tar.xz"
  sha256 "b493328721402f25cb7523f9cdc2f7d7c59f45ad999bde75c63c90604db0f20b"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a2f098c3bdb79a810d1a88f5492b405b165f2f71e5a0152db5abc180cfc0647a"
    sha256 arm64_big_sur:  "157869bc6537f08b996f33aa3e993d11de71634db860acd9e2067da4e45944f3"
    sha256 monterey:       "40d3b7ae291de1c94c41749a7806c197eb833fcb4351a0459d22941e6a0f4afb"
    sha256 big_sur:        "d3b93d4e8de01235e40fb13b1dc373b4ced6fd20595562f85c19f9c2713e2d93"
    sha256 catalina:       "87fd7582ecde41c95f49b9c64480c3282a4978c2e9f64a46a307aface7fb3b08"
    sha256 x86_64_linux:   "72c377e8e00865e5257124ff201fb5da8c8d3937c8ec5d4c50acbb694af6a0dd"
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

    # Fix for BSD sed. Reported upstream at:
    # https://gitlab.freedesktop.org/poppler/poppler/-/issues/1290
    inreplace "CMakeLists.txt", "${SED} -i", "\\0 -e"

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
