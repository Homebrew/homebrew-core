class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-26.03.0.tar.xz"
  sha256 "8b3c5e2a9f2ab4c3ec5029f28af1b433c6b71f0d1e7b3997aa561cf1c0ca4ebe"
  license "GPL-2.0-only"
  compatibility_version 2
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "48a891c5fd0edc2950e43f9dc4bc309c7e99a58ccaffa50aa5a22fd9214df35b"
    sha256 arm64_sequoia: "a992821eafac081984cb0098bea7f531fcb95645a11573246b6ad6607e6ea382"
    sha256 arm64_sonoma:  "77dd41ad1e4bbd232266b7d1b167ba3d2f33b2f1400fcb57889c59e5d64eab4c"
    sha256 sonoma:        "d71bf29c906bef479a506efd43b012d0d8c4b0b4889f40feda86ddb87bb11624"
    sha256 arm64_linux:   "8ece40082167007fd03794788c2f7de1e137a9fe1555636098a739306b83e9f3"
    sha256 x86_64_linux:  "f54feff3963960bc51007fa2866f6dc788766185b41a317625be981d10fd5ea6"
  end

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

  uses_from_macos "gperf" => :build
  uses_from_macos "curl", since: :monterey # 7.68.0 required by poppler as of https://gitlab.freedesktop.org/poppler/poppler/-/commit/8646a6aa2cb60644b56dc6e6e3b3af30ba920245

  on_macos do
    depends_on "gettext"
    depends_on "gpgme"
    depends_on "libassuan"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

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
      -DENABLE_QT5=OFF
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
