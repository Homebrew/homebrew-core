class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.08.0.tar.xz"
  sha256 "4a4bf7fc903b9f1a2ab7d04b7c5d8220db9bc6261cc73fdb9a826dc272f49aa8"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_ventura:  "c5437fa50bdc73e5904ed05b25b642c78e6249fa2c0b780bd89e0ba091ace342"
    sha256 arm64_monterey: "5cd3bb3a4ce8086a963cd345cb7a71551e330cbffeb8fe3efe66f960e874aff8"
    sha256 arm64_big_sur:  "38e26f00b0c8300bed7d33d6fe8416e7a85c78ad6e4ac85cf4cdf1655de6e62e"
    sha256 ventura:        "1d917325ca335c308553b4e518e2f5c9205ac3e2410c73feb0e1d97d61710d96"
    sha256 monterey:       "e7d4aaf33054f1d6995bf594e7e8f2884f8fa9f0b5c955feedbac7060498ad02"
    sha256 big_sur:        "19dca42c7a571f814e21c6eb5060f1cd864be69f468398d7c4909c59c22f6125"
    sha256 x86_64_linux:   "2cdc96e8c8fc37677c5cd1774f20b91cbfca994f540d6f0c556400d78f311ad4"
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
