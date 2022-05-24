class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  url "https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
  sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"
  license "LGPL-2.1-or-later"
  revision 9
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88c2bfae2fc095df973e6c1a24bd6424cdecb15a8cfe9e276cff215740e4150b"
    sha256 cellar: :any,                 arm64_big_sur:  "940dd231a42ef131d258dbee54abc10ea97b21ae026e0ac6c852c0d836643eb8"
    sha256 cellar: :any,                 monterey:       "16dcdc5257b5209a8447d806a0ff7500c6f6557c16b3238a0a2050e3b9e69431"
    sha256 cellar: :any,                 big_sur:        "4afff60a6a7fc188c713e084a2a5e13ead96be504bd32c4ebb55990567b01052"
    sha256 cellar: :any,                 catalina:       "9c2c0d3e4473fe2c55fc5d2449e2fd9ce4bad5ebf5e8b96a279bdca9813283ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f327e497ffaa82ca9fa47bc4bbe8d0549e096150eea5bab669d262957a74b61"
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
  depends_on "proj"
  depends_on "webp"

  def install
    ENV.cxx11

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

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
