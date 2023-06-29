class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 20
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
    sha256 cellar: :any,                 arm64_ventura:  "79c85af1f2d013527d99cfde7ce435182ac4936dbffaf517de4b7cdadedb8e07"
    sha256 cellar: :any,                 arm64_monterey: "fcac4f933cf4ff7c6b79801b6565ba4874ceaa6fa10396f25f0444f7e72a2564"
    sha256 cellar: :any,                 arm64_big_sur:  "b8fec18d2789e82ff93628f94fe42db682f020a3d3b58b6c9a74d8025160a20c"
    sha256 cellar: :any,                 ventura:        "818d535809aab37473863961a4ec536833010927520d0aa5b898d839ba1d164a"
    sha256 cellar: :any,                 monterey:       "55dc43165880201c53eb78c6ee786dcb8b112d90c24fb3029507f3b31eaec54c"
    sha256 cellar: :any,                 big_sur:        "81e7f65245f26229de82232066b3c2ee21331c4c08d0e34bfc5fea59cc5940f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed61f5be260ed934262a854f9a7c3e8b9053da51e80904ad4c89e72ec871504"
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
