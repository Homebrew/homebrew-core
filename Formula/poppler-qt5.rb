class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.03.0.tar.xz"
  sha256 "b04148bf849c1965ada7eff6be4685130e3a18a84e0cce73bf9bc472ec32f2b4"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_ventura:  "2094ead0ecb063c41b03e7587ce78bea693bacc3d33f379c7969684a1cf6cc18"
    sha256 arm64_monterey: "d1511c5ffea8356ffe3e087aa4520a093148170ee154145dfa21523efa5c10ed"
    sha256 arm64_big_sur:  "fef4bdc8612d30d589855c0905d43b6e5b231bd72ce46c050ed6f8bc154f6e06"
    sha256 ventura:        "39a3cb851e29ea6e22f53334d2ce640da0e4e77a564276df2efbd8473ebe3532"
    sha256 monterey:       "f3fd4a4da6a47ca130e576c37da5cd3be719285f9969998e1dcffa9caa545601"
    sha256 big_sur:        "5f6e81697a244f2267a4d44a53cef8e660449b326acc87cb1b15d7cc5150ccff"
    sha256 x86_64_linux:   "d20e8e6b23e4219c7894eb8bd3971a817cb34cabfbcb539f1815690fb30cb784"
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
