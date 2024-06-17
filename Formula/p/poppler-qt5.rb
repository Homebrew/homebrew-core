class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.04.0.tar.xz"
  sha256 "1e804ec565acf7126eb2e9bb3b56422ab2039f7e05863a5dfabdd1ffd1bb77a7"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_sonoma:   "f08fe036629f6df0514218e89c7f0dae4c686aa5caea6e9641f365ae47114760"
    sha256 arm64_ventura:  "f20dca04b250d5f9e26355d308c1d48fb9abcb1e577f38846577a7a35303afa8"
    sha256 arm64_monterey: "67331be704b6fdf64250926f0217843b9c50cf1f3dff215e4c1abf5fbbc5f107"
    sha256 sonoma:         "39a49e6863eb8207d2f448ab281e8ed1e430b11b086ce3f4a6db27576c8544d5"
    sha256 ventura:        "086bd249c3350ff3c488fde1897e05bf09583c1c20771a6d95eb1a32b60fbc97"
    sha256 monterey:       "0a07395ab099f762e5a1b79f2197acb956dc440ccfc901dd49a1bef7c3d58905"
    sha256 x86_64_linux:   "ff41c11021bcd1a25038892a82678ce35409055f76947b163eaf1772e4707cf7"
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
  depends_on "gpgme"
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
