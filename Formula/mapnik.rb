class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.23/mapnik-v3.0.23.tar.bz2"
  sha256 "4b1352e01f7ce25ab099e586d7ae98e0b74145a3bf94dd365cb0a2bdab3b9dc2"
  head "https://github.com/mapnik/mapnik.git"

  bottle do
    cellar :any
    sha256 "5b2b7057f5f2028f3b824f9d1c3b6339c424f859c58a11dda275095b96fa17fa" => :mojave
    sha256 "170678415472ba2586eae111ca11bac9c25a3166c1056e7d437c460287d84037" => :sierra
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
