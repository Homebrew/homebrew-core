class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 19
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
    sha256 cellar: :any,                 arm64_ventura:  "39590d4e99dc532d590708cd4cd5a218576cdb80f42174cf856251fe13ffb3bd"
    sha256 cellar: :any,                 arm64_monterey: "074f86cb6048289bbb23c0b14cde4df862cf7b93ab297c82dc5e8694a21894e1"
    sha256 cellar: :any,                 arm64_big_sur:  "53af7f29035a5bdaf4b27aa68c4066fd237e066d73547d37e6d9948fd6ebb317"
    sha256 cellar: :any,                 ventura:        "d63a70bac6ffe8564f5650ea91a7fd12949f41519df6c87dd90b370914d3fa4a"
    sha256 cellar: :any,                 monterey:       "fb1afd8b5526fc5512a5f5162cf3c696bd9ace12423bd36cc991060729225be2"
    sha256 cellar: :any,                 big_sur:        "f74c1e2bdc086ca09c94462b38f0afcd7e2d104b9ee414408b6580fee836ec04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9048875824aac0ca301207fee6efc071c5e5920e84d8344015f5284483f4a1dc"
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
