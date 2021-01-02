class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.24/mapnik-v3.0.24.tar.bz2"
  sha256 "75520a98ff688f48e4dd36e86199530ea084b296f2d4972478db1fcb3475d71c"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/mapnik/mapnik.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "e8e6c39326cb7982c82597fda507635ce80d6b2cbdf261d15330ae2d680332a4" => :big_sur
    sha256 "a2383ae9820b4ad50ab5ab72e16d85374ff723eb37ad1ea3a07edc1452ab1286" => :arm64_big_sur
    sha256 "e50c65129ab5a5a2348f7177620aae74094aa5830fb0b5717f907e12fca5ffae" => :catalina
    sha256 "3e7c475e36c0d2712069736b3e983d1820ff0662ed735a182f6d475e876ea7c3" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "postgresql"
  depends_on "proj"
  depends_on "webp"

  # Fix for Boost >= 1.75
  # https://github.com/mapnik/mapnik/issues/4201
  patch do
    url "https://github.com/mapnik/mapnik/commit/49e0ef18.patch?full_index=1"
    sha256 "d8f12a85ad78f95e3cb2b3b5485e586c250fe2230a90874c0a70843189cc42f5"
  end

  def install
    ENV.cxx11

    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/mapnik/mapnik/issues/4036
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

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
      PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config
      PNG_INCLUDES=#{libpng}/include
      PNG_LIBS=#{libpng}/lib
      PROJ_INCLUDES=#{proj}/include
      PROJ_LIBS=#{proj}/lib
      TIFF_INCLUDES=#{libtiff}/include
      TIFF_LIBS=#{libtiff}/lib
      WEBP_INCLUDES=#{webp}/include
      WEBP_LIBS=#{webp}/lib
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end
