class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-26.04.0.tar.xz"
  sha256 "b0955163114af96bc0106f68cb24daf973a629462453d8b82775f81b0d4e0693"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"] # see README-XPDF
  compatibility_version 1
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "bee38516cb7a8a3417615eae7c07a3f92a3557131fc619949fb75efc1af02161"
    sha256 arm64_sequoia: "830bd40bd7832856b415d1b30d2e8326f25f7c9862a54d81d986deedb3569e60"
    sha256 arm64_sonoma:  "ce7f53d9d584acd0fb02e3e2460f17e60f47b8ac54614a45e4d81c2e1cf7691d"
    sha256 sonoma:        "a0bd36a59abf205d3998bfb78750b252eba1b7e7af4ff7122998253303090529"
    sha256 arm64_linux:   "3a7764bb4f098957677728f0506b3a2423a4cd1c37e6fc27cbc89b117eed7e15"
    sha256 x86_64_linux:  "3bb8f819256198559fe62e783d3b0e5c004494530e7bab36c91e9f727226c7c1"
  end

  keg_only "it conflicts with poppler"

  deprecate! date: "2026-05-19", because: "is for end-of-life Qt 5"
  disable! date: "2027-05-19", because: "is for end-of-life Qt 5"

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
