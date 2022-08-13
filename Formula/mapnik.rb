class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
  sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"
  license "LGPL-2.1-or-later"
  revision 11
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "687baaff1f0fc30fa02fe065d3aa0d9478cd69536bcb8e292ee70731abc0a71e"
    sha256 cellar: :any,                 arm64_big_sur:  "f69643fc4b62a5f6c1b5e016149552e0a0a6e0ba56454b908638fcdb6693ce5e"
    sha256 cellar: :any,                 monterey:       "debcd40aba920e5b223383bc8fa0c15a51163408d6288e72ed8bfaa99f4652d2"
    sha256 cellar: :any,                 big_sur:        "8a0de35f92f305c2eb531029e7da35c0cb445ac01cc9404986d454e0380dbe19"
    sha256 cellar: :any,                 catalina:       "a00a963a2647cbffb710fd3d3f55923a017b7ddefa3d010d11fdfa62ae95673d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc6ae200e9a45b098f6b40dd0d2268c73db13b75c75309e586a4a306db57f47"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "webp"

  def install
    ENV.cxx11

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    boost = Formula["boost"].opt_prefix
    freetype = Formula["freetype"].opt_prefix
    harfbuzz = Formula["harfbuzz"].opt_prefix
    icu = Formula["icu4c"].opt_prefix
    jpeg = Formula["jpeg"].opt_prefix
    libpng = Formula["libpng"].opt_prefix
    libtiff = Formula["libtiff"].opt_prefix
    proj = Formula["proj"].opt_prefix
    webp = Formula["webp"].opt_prefix

    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      PREFIX=#{prefix}
      BOOST_INCLUDES=#{boost}/include
      BOOST_LIBS=#{boost}/lib
      CAIRO=True
      CPP_TESTS=False
      FREETYPE_CONFIG=#{freetype}/bin/freetype-config
      GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config
      HB_INCLUDES=#{harfbuzz}/include
      HB_LIBS=#{harfbuzz}/lib
      ICU_INCLUDES=#{icu}/include
      ICU_LIBS=#{icu}/lib
      INPUT_PLUGINS=all
      JPEG_INCLUDES=#{jpeg}/include
      JPEG_LIBS=#{jpeg}/lib
      NIK2IMG=False
      PG_CONFIG=#{Formula["libpq"].opt_bin}/pg_config
      PNG_INCLUDES=#{libpng}/include
      PNG_LIBS=#{libpng}/lib
      PROJ_INCLUDES=#{proj}/include
      PROJ_LIBS=#{proj}/lib
      TIFF_INCLUDES=#{libtiff}/include
      TIFF_LIBS=#{libtiff}/lib
      WEBP_INCLUDES=#{webp}/include
      WEBP_LIBS=#{webp}/lib
    ]

    inreplace "Makefile", "PYTHON = python", "PYTHON = python3"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end
