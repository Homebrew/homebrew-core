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
    rebuild 1
    sha256 arm64_ventura:  "fd63f1982dd0d3841d91968c419dd6b243ae6b557a714ce76980e3ec78814072"
    sha256 arm64_monterey: "4853cf0f59a2d43b2dc1ee36bb199b3cf306e70718630338d494f743b5bf5451"
    sha256 arm64_big_sur:  "329932614c8dc9d3b10deecfc26c7a787b4ea810e657bd1a0c0ae7385d83e8c9"
    sha256 ventura:        "d4ec3b0b24dd18bfd3b89fdabb12f620a25ff8af7d887d107735f6f08a802157"
    sha256 monterey:       "035d5675efb503e43f7ee6bd88bb1d75a5afcec9e2d7e094fd5e9e056e71036f"
    sha256 big_sur:        "d804cc82ab548633b59172c3f2c48a205a4351ee9b02aa18d5101bf07f21da41"
    sha256 catalina:       "ffcbc6c557151fd0e9c9d7246569e2909aa97fa03fcf26fd6db2846d3b1b61ad"
    sha256 x86_64_linux:   "f89868c9d585140de94c0e3b0d699707ed1f86e1ea4be098102b4ae997e4646c"
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
