class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 16
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
    sha256 cellar: :any,                 arm64_ventura:  "af5b19972711cd96a6cb0c2665800179302f4fa41fcc36c78bcedb59bba01edc"
    sha256 cellar: :any,                 arm64_monterey: "81d9f0bdc1d368c6730d5a5ed656553d119ee13960c61f9ac9ee31f04864e0f2"
    sha256 cellar: :any,                 arm64_big_sur:  "89ddc6995c8926ea3f636f67ccb5b4487a7ab2abb6efef49e035e44b2b147370"
    sha256 cellar: :any,                 ventura:        "4795fa9f23cb3e1a694fd9b7775fb17e40e754f3827b8ce8480aba65bac70835"
    sha256 cellar: :any,                 monterey:       "05ad03a3eae25af6e59a550d7a1df9f7fd83405dcf4b8a655d30ff67ee4b0f93"
    sha256 cellar: :any,                 big_sur:        "655892f0f5d0f5c01c55671fd2dd6e9c42378db1352eb122ae59a268a6848add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a7381004b369d277ceef3ee237ec5bc3249963d4102a28679e185a806fba8df"
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
