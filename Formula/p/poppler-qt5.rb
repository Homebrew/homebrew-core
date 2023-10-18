class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.10.0.tar.xz"
  sha256 "31a3dfdea79f4922402d313737415a44d44dc14d6b317f959a77c5bba0647dd9"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_sonoma:   "d956b60eba746fab66c0f971aef85929357d6771bb71b482ea4ed35f9c2a13b6"
    sha256                               arm64_ventura:  "ca3f3423ca69471c6fcbe374cc991743a34d1fad314df30d70701df7069da631"
    sha256                               arm64_monterey: "a9c538cbf287297bdb8fd2d486eba8e789e0bffed8d6ac2f759db6d0a0fc7c1a"
    sha256                               sonoma:         "4803105d5604cadbdda67a92b8b38f80cf3703c016349b401f4e5303655a58a7"
    sha256                               ventura:        "ec44476be668fed187c844193e92e0ce76b5b9ebb29392b7cb84ace6981178eb"
    sha256                               monterey:       "0295d91f895a5e24f1137606b6c5642ec458fa771a70782a321542a4ed8d52bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b357301337f4afac37fbf58ea7de0bea3d123c82048ac9d68dd3d76595768b6"
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
