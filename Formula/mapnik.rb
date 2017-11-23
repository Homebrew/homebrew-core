class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "http://www.mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.13/mapnik-v3.0.13.tar.bz2"
  sha256 "d6213d514a0e3cd84d9bfcb6d97208d169ffcaae1f36250f6555655cdfe57bcc"
  revision 2
  head "https://github.com/mapnik/mapnik.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "72187ae6b0ced95e532b9c93ffd705660e1e01cfb0eb0ba47e020e1250c74b7b" => :high_sierra
    sha256 "d23f0b97fca875c08b70cd5174b4ddb83362bafca3d9b640e10ac3bfce354962" => :sierra
    sha256 "4284fe8222588309d9cfca91d40d2fa9d57975f8fe81e51d095ecff78ba44448" => :el_capitan
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
  depends_on "gdal2" => :optional
  depends_on "postgresql" => :optional
  depends_on "cairo" => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  # Upstream issue from 18 Jul 2017 "3.0.15 build failure with icu-59"
  # See https://github.com/mapnik/mapnik/issues/3729
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/baacb3b/mapnik/3.0.13-icu4c-59.patch"
    sha256 "b8c6d1e7477893b0024f4b79410b4499dd6fc7991d7d233a902b3a5e627854b7"
  end

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

    if build.with?("gdal") && build.with("gdal2")
      odie "Options --with-gdal and --with-gdal2 are mutually exclusive."
    end
    args << "GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config" if build.with? "gdal"
    args << "GDAL_CONFIG=#{Formula["gdal2"].opt_bin}/gdal-config" if build.with? "gdal2"

    args << "PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config" if build.with? "postgresql"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/mapnik-config --prefix").chomp
  end
end
