class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.04.0.tar.xz"
  sha256 "1e804ec565acf7126eb2e9bb3b56422ab2039f7e05863a5dfabdd1ffd1bb77a7"
  license "GPL-2.0-only"
  revision 1
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "5d74f29c70add1be6fb3c7c3a9abbec589a6ca2f6df7e7676bb7fcee3ffdd50f"
    sha256 arm64_sonoma:   "8b487935981de358c8be92fbf3325279d37f4ea15f5e00a1c061e7b534dbda12"
    sha256 arm64_ventura:  "dad153bde1d968931cdce8acf850519bfb124053e14b7320a7bcfb71e42122e4"
    sha256 arm64_monterey: "aa50112c89e22500caf026bbc4a6dfd4bf4073cd21e6ec1d8fcda3f3d3fc175d"
    sha256 sonoma:         "9bb5a73485ce08ad41882c384b403b041e69aa18cda57ad9cc0557c724e2d3c4"
    sha256 ventura:        "d3aa8c09cd2a5848ee99ff138814553f3d6206a0c96ad216fb55e6968918422c"
    sha256 monterey:       "c5e2890d19c2c3d42b951ea067fc5186d348f6c8c1862ba4e6f120fe96a4312d"
    sha256 x86_64_linux:   "7b73544fa9db0d4264fb2a3c2816f50eac61c33a7a1a060ff92dfcbc7fd4783d"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl", since: :monterey # 7.68.0 required by poppler as of https://gitlab.freedesktop.org/poppler/poppler/-/commit/8646a6aa2cb60644b56dc6e6e3b3af30ba920245
  uses_from_macos "zlib"

  on_macos do
    depends_on "libassuan"
  end

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
    ENV["PKG_CONFIG_SYSTEM_INCLUDE_PATH"] = "/usr/include" if OS.mac? && MacOS.version < :mojave

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
