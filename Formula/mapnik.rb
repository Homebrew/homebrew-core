class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "http://www.mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.19/mapnik-v3.0.19.tar.bz2"
  sha256 "5bf17afaf456e63021a4c948e25cf5e756782ef369226441a1e436adc3e790e9"
  head "https://github.com/mapnik/mapnik.git"

  bottle do
    cellar :any
    sha256 "f41d9cb363acd3db3def9574e1a83b973ec95bb403d8284172aa7d282043ca60" => :high_sierra
    sha256 "7ea965c66cc3978fab4754f6aa3bc064eda4f16c2b669b57dc96796439765955" => :sierra
    sha256 "4183d1662c44bb8efad476472b94ea8c85c387bbac8e8382e1f04865937f94e8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "webp"
  depends_on "gdal" => :optional
  depends_on "postgresql" => :optional
  depends_on "cairo" => :optional

  needs :cxx11

  def install
    ENV.cxx11

    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    icu = Formula["icu4c"].opt_prefix
    boost = Formula["boost"].opt_prefix
    proj = Formula["proj"].opt_prefix
    jpeg = Formula["jpeg"].opt_prefix
    libpng = Formula["libpng"].opt_prefix
    libtiff = Formula["libtiff"].opt_prefix
    freetype = Formula["freetype"].opt_prefix
    harfbuzz = Formula["harfbuzz"].opt_prefix
    webp = Formula["webp"].opt_prefix

    args = ["CC=\"#{ENV.cc}\"",
            "CXX=\"#{ENV.cxx}\"",
            "PREFIX=#{prefix}",
            "CUSTOM_CXXFLAGS=\"-DBOOST_EXCEPTION_DISABLE\"",
            "ICU_INCLUDES=#{icu}/include",
            "ICU_LIBS=#{icu}/lib",
            "JPEG_INCLUDES=#{jpeg}/include",
            "JPEG_LIBS=#{jpeg}/lib",
            "PNG_INCLUDES=#{libpng}/include",
            "PNG_LIBS=#{libpng}/lib",
            "HB_INCLUDES=#{harfbuzz}/include",
            "HB_LIBS=#{harfbuzz}/lib",
            "WEBP_INCLUDES=#{webp}/include",
            "WEBP_LIBS=#{webp}/lib",
            "TIFF_INCLUDES=#{libtiff}/include",
            "TIFF_LIBS=#{libtiff}/lib",
            "BOOST_INCLUDES=#{boost}/include",
            "BOOST_LIBS=#{boost}/lib",
            "PROJ_INCLUDES=#{proj}/include",
            "PROJ_LIBS=#{proj}/lib",
            "FREETYPE_CONFIG=#{freetype}/bin/freetype-config",
            "NIK2IMG=False",
            "CPP_TESTS=False", # too long to compile to be worth it
            "INPUT_PLUGINS=all"]

    if build.with? "cairo"
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config" if build.with? "gdal"
    args << "PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config" if build.with? "postgresql"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/mapnik-config --prefix").chomp
  end
end
