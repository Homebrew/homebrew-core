class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.04.0.tar.xz"
  sha256 "b6d893dc7dcd4138b9e9df59a13c59695e50e80dc5c2cacee0674670693951a1"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "76893c80ac9e1b3840913deb64e025df0bd3bea6a33c2f6579a6951e93499bf8"
    sha256                               arm64_monterey: "524ad7bfb5d3d8c3d50832e7f32e7b6ba4b391b4d5e25d816f110990b5e0abca"
    sha256                               arm64_big_sur:  "61c4f4c4653671f5577dbbfcf2ff1c9b8873b8f86d5f6f9363a65c53bfb49c9e"
    sha256                               ventura:        "7177c7a431c174480759c1a65926836182897380fdcbb183657cf98139e6e4d5"
    sha256                               monterey:       "d99b66362aeb491701141b4589b398981c77283204b397880880c1590b032def"
    sha256                               big_sur:        "598869db64fec3087e0023aa5624946f817029eb213c1d8e157e26b15bb36bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ab78100f0a013ad8b614eca2d38f54c7bae289ba35177fa1dd35a348e0617e"
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
