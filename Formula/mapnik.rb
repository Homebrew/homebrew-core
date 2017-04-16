class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "http://www.mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.13/mapnik-v3.0.13.tar.bz2"
  sha256 "d6213d514a0e3cd84d9bfcb6d97208d169ffcaae1f36250f6555655cdfe57bcc"
  revision 1
  head "https://github.com/mapnik/mapnik.git"

  bottle do
    cellar :any
    sha256 "79f1a036cd98eb7d94f416e5c8e0ad55a9d92aba90a0b09a5df6def0dd02ac1b" => :sierra
    sha256 "2f6d9de1df7ab5266684c01a2c12577bdbf9a8e77fe58e5c130865c06904234e" => :el_capitan
    sha256 "44d3c6b9302e185c3ad2933fdcb28e666891f2ed2cffd2fa506ea031ba676f9a" => :yosemite
  end

  depends_on "pkg-config" => :build
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

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11
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
