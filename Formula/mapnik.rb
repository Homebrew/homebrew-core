class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 18
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  stable do
    url "https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
    sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"

    # Allow Makefile to use PYTHON set in the environment. Remove in the next release.
    patch do
      url "https://github.com/mapnik/mapnik/commit/a53c90172c664d29cd877302de9790a6ee9b5330.patch?full_index=1"
      sha256 "9e0e06fd64d16b9fbe59d72402e805c94335397385ab57c49a6b468b9cc5a39c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd6a45c2381d28a92e083841b6a7fdf30cf7d97c380f6c336b30f27774b78fb3"
    sha256 cellar: :any,                 arm64_monterey: "2fce2dbd5abda6b6c9cc4caf0fde8ce76e0990aa316c3e74dba3e37cecd464fb"
    sha256 cellar: :any,                 arm64_big_sur:  "3a9e8dbe246d33311408242b2bc0dfb0bc0dc26df9c24dbc05f7f15ae2810b9c"
    sha256 cellar: :any,                 ventura:        "88d5bc0dcad28ba174130a94b39246a4f1a43c64f250285bd57abea9c90640c1"
    sha256 cellar: :any,                 monterey:       "e1c642f078382627510a18b20a1b4853ecc433079723fd2c428610c8ed7ba23d"
    sha256 cellar: :any,                 big_sur:        "e1630d6000ae2550e4332ab50c8aeca175ce3fc5ae8172a4948e65859aa6b3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163dd94872593e06817a0476845438f6ebf460a6c7caca172695715eeac9ef15"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "webp"

  def install
    ENV.cxx11
    ENV["PYTHON"] = "python3.9"

    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    boost = Formula["boost"].opt_prefix
    freetype = Formula["freetype"].opt_prefix
    harfbuzz = Formula["harfbuzz"].opt_prefix
    icu = Formula["icu4c"].opt_prefix
    jpeg = Formula["jpeg-turbo"].opt_prefix
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
    # upstream issue, see https://github.com/boostorg/phoenix/issues/115
    # workaround to avoid the inclusion of `boost/phoenix/stl/tuple.hpp`
    args << "CUSTOM_CXXFLAGS=-DBOOST_PHOENIX_STL_TUPLE_H_"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end
