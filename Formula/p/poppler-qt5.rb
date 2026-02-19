class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-26.02.0.tar.xz"
  sha256 "dded8621f7b2f695c91063aab1558691c8418374cd583501e89ed39487e7ab77"
  license "GPL-2.0-only"
  revision 1
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_tahoe:   "ee0859541da7efe87b45d42d7047abddef9986ccafa0e0914245a6dc53bf0ed1"
    sha256 arm64_sequoia: "a76a56d592278709f6d3113d0a6eebba60e6fcb7f09c0eed86fa4a5a041a1197"
    sha256 arm64_sonoma:  "940b6780d9c2a7cae22b65b076d7218c085d1899aeab0d82b8dc7ce90244b0bf"
    sha256 sonoma:        "a835672a8721f511fdd492b87f74341013657dba4379a6cb3ec4a18714a4a766"
    sha256 arm64_linux:   "dc3fcb5ba9cea0e4b0498f5ac3fcec83128fc8dc447e38e754511f714754fb14"
    sha256 x86_64_linux:  "15c9229990549947f869ed62c6974774041a537370107de367ec9cae917ebffa"
  end

  keg_only "it conflicts with poppler"

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gpgmepp"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "gpgme"
    depends_on "libassuan"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
    sha256 "c835b640a40ce357e1b83666aabd95edffa24ddddd49b8daff63adb851cdab74"

    livecheck do
      url "https://poppler.freedesktop.org/"
      regex(/href=.*?poppler-data[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  def install
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
