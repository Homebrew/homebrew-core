class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.0.24/mapnik-v3.0.24.tar.bz2"
  sha256 "75520a98ff688f48e4dd36e86199530ea084b296f2d4972478db1fcb3475d71c"
  license "LGPL-2.1-or-later"
  head "https://github.com/mapnik/mapnik.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "48a0c9620a9ab8b0bdc9a5dce860b10929131fd4111d7867bb65b3edc3e5801f" => :big_sur
    sha256 "ae4b934d41a83aae33c9683075eaead205b6394b6907be7c9807bd6dd335bb3c" => :arm64_big_sur
    sha256 "f729bbdbe769cf517ac2a13ee2ef427b37ff0a6f81a57ad80f1469daf0352404" => :catalina
    sha256 "0faa41637365731b2208661702c1c4f3acef2d37e8733fbd063dc72d45b53f29" => :mojave
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

  on_macos do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/57e635431e09fa1b00f3e1fd9574ad516de13308/mapnik/mapnik-2.0.23.patch"
      sha256 "b946071a95a52757e1aabb03ed7768408b864e20f46cbea39bda2cd1499b256c"
    end
  end

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
