class PopplerQt6 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-26.09.0.tar.xz"
  sha256 "8059eadb6805340768f138c465b57f8164c92b4a0773c37ef031ea6c0d987b2e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"] # see README-XPDF
  compatibility_version 1
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_tahoe:   "a32905dfa95a90eb7e63096ed10177ee0454d6361091d91eedd8b5fdda9d8c4f"
    sha256 arm64_sequoia: "8cc384d3669c7cdb0743d01dc0516940fd2ac79444651231147e6d0986ef56f6"
    sha256 arm64_sonoma:  "7dd6a82dbda4d9c1be5fd5296e644d4dadfeee1616989752defa29bcbefe015c"
    sha256 arm64_linux:   "896b8648c91e9c6edddac7bdcf5232bfd077c4e0ec4af92ec970ed229b419fe1"
    sha256 x86_64_linux:  "7722c94c308b76b33806073737afb78514efbef3cac820da27bae67f11d1da4c"
  end

  keg_only "it conflicts with poppler"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gpgmepp"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qtbase"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "gpgme"
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
    args = %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_GLIB=ON
      -DENABLE_QT5=OFF
      -DENABLE_QT6=ON
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build_shared", *args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/libpoppler.a"
    lib.install "build_static/cpp/libpoppler-cpp.a"
    lib.install "build_static/glib/libpoppler-glib.a"

    # Add extra metafiles for licensing information
    prefix.install "COPYING3", "README-XPDF"

    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system bin/"pdfinfo", test_fixtures("test.pdf")
  end
end
