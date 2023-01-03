class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.01.0.tar.xz"
  sha256 "fae9b88d3d5033117d38477b79220cfd0d8e252c278ec870ab1832501741fd94"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_ventura:  "7a98274ee29aa5bade1ba1172e24b5d3e2bc19d80c779e7b25537516a912f897"
    sha256 arm64_monterey: "3a093665d2e0282668aa64229a24eca163155da03239d92c3649e5e6d4696499"
    sha256 arm64_big_sur:  "a9ad2eb353e1ce0e45a753eefbe3824b6c9851ffe40004c7ff86ac0d692b4cfd"
    sha256 ventura:        "04fb1b004e2b17876a1e910e54583648d3e7f1b8fc2d97ad58cce415d246dc89"
    sha256 monterey:       "639bab34e548ad0e474c798553199899f1532e7b6a84cc600df0c4f3ec764fd1"
    sha256 big_sur:        "4e20bd89634e53d78635d3e65287dda33ee5e4aaa453edf742c06e1a6afb3166"
    sha256 x86_64_linux:   "821ebc1d273efa2fe59c86154e67b5e95b4b9f8c9905389a0f306d1cbc2be442"
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
