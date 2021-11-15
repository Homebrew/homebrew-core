class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-21.11.0.tar.xz"
  sha256 "31b76b5cac0a48612fdd154c02d9eca01fd38fb8eaa77c1196840ecdeb53a584"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_monterey: "97ec98ea7bfa55745ffabcf6f5728bcf5ecef7634f7e5e3d5b05436d1d6814fd"
    sha256 arm64_big_sur:  "f18ed9acb1380c09a482af222e26e3bfd6cef24bb50635d602e20338586d423b"
    sha256 big_sur:        "10d7eaa9579959aaff146a82c780d0dea4e7a966592760b0bc9c8cb1fc8e5244"
    sha256 catalina:       "56f321088f630328174561c41f64aadf5bd3b560851bbded7db905d17b82205f"
    sha256 x86_64_linux:   "b60f0d6999b4527e67ac0b989aea8c89c80e7576f0648ea2776684a92fc3ed14"
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
