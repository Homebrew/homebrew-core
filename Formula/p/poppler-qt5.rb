class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.02.0.tar.xz"
  sha256 "19187a3fdd05f33e7d604c4799c183de5ca0118640c88b370ddcf3136343222e"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_sonoma:   "79ee0758432e8e2b091ed51da0610666950ccd7e0fe08a26d20ed03d4d63ed80"
    sha256                               arm64_ventura:  "e03edbc159f31c76dd0d0cdd44e38c671747247bb7e8f52dc4f11bb9250df8a0"
    sha256                               arm64_monterey: "f6a64debabf7e90aa81efcfc71ca40f5f6570b3122aadfc241f16bf39e35ee4e"
    sha256                               sonoma:         "d379b57b4396856323b456d8297f5801afe42ffabed61efd589dd6370fc2dd85"
    sha256                               ventura:        "3cc3932d671faac18995b1821b22725d16cc8144fe087e8f81fbd95f8e4f70bb"
    sha256                               monterey:       "4e3d1d9c0aa1656f6e93b22fe943ce26b428e1befac4613d250c9ed63d26bb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b514d2690f47cddf6ed04b1dd42c26f093d1211c58b72f688259b95067c143"
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
