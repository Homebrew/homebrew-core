class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.03.0.tar.xz"
  sha256 "bafbf0db5713dec25b5d16eb2cd87e4a62351cdc40f050c3937cd8dd6882d446"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_sonoma:   "126947b9eb8971fdc3fafe0987b96cb9ada09c37cf2639764416c6ea66b8f29e"
    sha256 arm64_ventura:  "bd8d09ac6fd894e8bbf9de205359c0b3684bb78d94930fe84c6c36de4a4fc3e6"
    sha256 arm64_monterey: "76da5cd3e22c17df1fb0b786bad3b0f01405b6dae405ebbd3fb63edde409b52b"
    sha256 sonoma:         "3386d25e18efac4687e9922f233c2a877be1ba2f29c2f678e34b115476316a34"
    sha256 ventura:        "f7e51e2e3f1c01c01b970a74bc5b94604f91600b999bb4aead4431f36246696d"
    sha256 monterey:       "3301e80c647bc2d8127a4f6a5e76a844bd95f11d693ba51df534e8dcbfca82d9"
    sha256 x86_64_linux:   "dd1d966d6c488179133aaaed6b1e3f06abaed1f261f2688c7a4d0d890b499dba"
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
