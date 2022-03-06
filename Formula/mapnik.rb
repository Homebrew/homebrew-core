class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
  sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"
  license "LGPL-2.1-or-later"
  revision 7
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f75f2bf4dc6654ec494ba60f11c69e1e2e37319b54eaef496fa393122559ddea"
    sha256 cellar: :any,                 arm64_big_sur:  "cdd140c9ac7b3237c30e57fddf5be28a3299e08981206a01547e9d108697fac9"
    sha256 cellar: :any,                 monterey:       "06b23564d22c0ada831fbb6b99c1d84497e887d58f352d233c13671db8d97ee2"
    sha256 cellar: :any,                 big_sur:        "325112aaaed31601d2d5164f62aa326037efa40131e00e960e5162c8b9cecea2"
    sha256 cellar: :any,                 catalina:       "e6821246dac145001f0d7f04d63f2a14161ac61302efa22e4ca0544258076433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a360d13e752a6029eef96a4d7723922e8e7e40c75970e4ce78199ebfe9e325"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
  depends_on "proj@7"
  depends_on "webp"

  def install
    ENV.cxx11

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

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

    inreplace "Makefile", "PYTHON = python", "PYTHON = python3"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end
