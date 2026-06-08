class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-26.04.0.tar.xz"
  sha256 "b0955163114af96bc0106f68cb24daf973a629462453d8b82775f81b0d4e0693"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"] # see README-XPDF
  compatibility_version 3
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?poppler[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dc47afa401538297b7afd6914363501443d832031434a2f0d3fde4aa3d75810e"
    sha256 arm64_sequoia: "17eab9fcc315f760a5092f6856d2385e10cba3787a8d61e36979d2a1c9fcc18b"
    sha256 arm64_sonoma:  "c0828630e30e1216f7fb59adea4cefdc329ed8692e8aaeb059115cc54ac18f96"
    sha256 sonoma:        "bbe9dff4184b7d629fdff43b540d8dfc53db559036f988daf752f02bf0714bd7"
    sha256 arm64_linux:   "3bd08cb0df5ccee7aeed0a7529867c063beaa0fec303c79fd7dd84c1d66971e6"
    sha256 x86_64_linux:  "e43a4677edf16c8af9f6e2b8fba9fec37ab610339a6d5a76eccac687b288d7b7"
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
