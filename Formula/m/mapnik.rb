class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 21
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  # TODO: Try switching to CMake build on next release as it works better with
  # Homebrew's build environment and avoids `--env=std` when using `scons`.
  stable do
    url "https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
    sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"

    # Fix build with Scons 4 using Arch Linux patch. Remove in the next release.
    # Ref: https://github.com/mapnik/mapnik/commit/84a05a6597a941acfad220dae3fbfe5d20bfeb26
    patch do
      url "https://raw.githubusercontent.com/archlinux/svntogit-community/239768d7cd1217d5910d3f7d8ace86a7f85ad23c/trunk/scons4.patch"
      sha256 "79a85ddba3ec17b86cb216e21442611498a9f2612f03e98708057b3c3a6e8b06"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "0dca5deae922d9f2b39fe75690dabfd20331a7449d1af97c16d16c39ece30759"
    sha256                               arm64_monterey: "098cdc2b84b8bfdaba32c5320942bd0e636e63295446dfc9cf9b7e2cfdda6010"
    sha256                               arm64_big_sur:  "477d220e0bb4096d27ee3821c1c0a99b3733c4e1b6970f27e6acc6881d5adc83"
    sha256                               ventura:        "17f5fab836011f04c4ee4071ccf3d233dfc27b94172487d1a20d98395ec4220a"
    sha256                               monterey:       "1d5322c0b334abf0e48f55e0a891947cfc62e0c880340878d390921b5595af3e"
    sha256                               big_sur:        "0f5a5d5c01e90b51cbe47a14a1f5f86ae45d3970d9374de6ffb84cd42cf75c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a8d9c4faa4d700cdc75acfb01544dba0602316632ee1a8f29e18095b93bbe6"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
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
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  def install
    boost = Formula["boost"]
    harfbuzz = Formula["harfbuzz"]
    icu = Formula["icu4c"]
    jpeg = Formula["jpeg-turbo"]
    libpng = Formula["libpng"]
    libpq = Formula["libpq"]
    libtiff = Formula["libtiff"]
    proj = Formula["proj"]
    sqlite = Formula["sqlite"]
    webp = Formula["webp"]

    # upstream issue, see https://github.com/boostorg/phoenix/issues/115
    # workaround to avoid the inclusion of `boost/phoenix/stl/tuple.hpp`
    ENV.append "CXXFLAGS", "-DBOOST_PHOENIX_STL_TUPLE_H_"

    if OS.linux?
      deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
        ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
      end
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end

    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      CUSTOM_CFLAGS=#{ENV.cflags}
      CUSTOM_CXXFLAGS=#{ENV.cxxflags}
      CUSTOM_LDFLAGS=#{ENV.ldflags}
      PREFIX=#{prefix}
      FAST=True
      CPP_TESTS=False
      INPUT_PLUGINS=all
      BOOST_INCLUDES=#{boost.opt_include}
      BOOST_LIBS=#{boost.opt_lib}
      FREETYPE_CONFIG=#{Formula["freetype"].opt_bin}/freetype-config
      GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config
      HB_INCLUDES=#{harfbuzz.opt_include}
      HB_LIBS=#{harfbuzz.opt_lib}
      ICU_INCLUDES=#{icu.opt_include}
      ICU_LIBS=#{icu.opt_lib}
      JPEG_INCLUDES=#{jpeg.opt_include}
      JPEG_LIBS=#{jpeg.opt_lib}
      PG_CONFIG=#{libpq.opt_bin}/pg_config
      PNG_INCLUDES=#{libpng.opt_include}
      PNG_LIBS=#{libpng.opt_lib}
      PROJ_INCLUDES=#{proj.opt_include}
      PROJ_LIBS=#{proj.opt_lib}
      SQLITE_INCLUDES=#{sqlite.opt_include}
      SQLITE_LIBS=#{sqlite.opt_lib}
      TIFF_INCLUDES=#{libtiff.opt_include}
      TIFF_LIBS=#{libtiff.opt_lib}
      WEBP_INCLUDES=#{webp.opt_include}
      WEBP_LIBS=#{webp.opt_lib}
    ]

    system "scons", "configure", *args
    system "scons", "install", "--jobs=#{ENV.make_jobs}"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end
