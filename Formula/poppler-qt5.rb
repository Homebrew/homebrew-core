class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  # NOTE: Keep this version in sync with poppler
  url "https://poppler.freedesktop.org/poppler-21.10.0.tar.xz"
  sha256 "964b5b16290fbec3fae57c2a5bcdea49bb0736bd750c3a3711c47995c9efc394"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_big_sur: "b04bd910e016cf419a9f4cd26426225194819043fbb03287ce05b5fe1e5738f5"
    sha256 big_sur:       "9c3edf61ef29b2908c8e476c67163a6c0c8b689d834d93323431a32a86b44026"
    sha256 catalina:      "dd442783223a090fc558d6515b8dac8d4fac6a522c1c9878a827e28638a40ea6"
    sha256 mojave:        "0b3aa91d6df18c74425f17f4f0d194e91b62dacccd42e7caadb9e6342a77bca4"
    sha256 x86_64_linux:  "806a60be7dbaeca537e075f4eb5f2eeb62641c2a0ebaf0a401bdb57d33308c39"
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
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

    if OS.mac?
      libpoppler = (lib/"libpoppler.dylib").readlink
      [
        "#{lib}/libpoppler-cpp.dylib",
        "#{lib}/libpoppler-glib.dylib",
        "#{lib}/libpoppler-qt5.dylib",
        *Dir["#{bin}/*"],
      ].each do |f|
        macho = MachO.open(f)
        macho.change_dylib("@rpath/#{libpoppler}", "#{opt_lib}/#{libpoppler}")
        macho.write!
      end
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
