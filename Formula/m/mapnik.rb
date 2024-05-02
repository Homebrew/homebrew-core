class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 28
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

    # Fix build with Boost v1.83 using Arch Linux patch. Remove in the next release.
    # Ref: https://github.com/mapnik/mapnik/pull/4413
    patch do
      url "https://github.com/mapnik/mapnik/commit/26eb76cc07210d564d80d98948770c94d27c5243.patch?full_index=1"
      sha256 "085408d6a38c77df7f333047bb1568bf0dfdf9c3b87fd9001997ba9b22be6d4c"
    end

    # Fix build with `boost` 1.85.0 using open PR.
    # PR ref: https://github.com/mapnik/mapnik/pull/4448
    patch do
      url "https://github.com/mapnik/mapnik/commit/8088aa4319fd54d41e9b8534b964d113f687fc7f.patch?full_index=1"
      sha256 "3d37cfb1b52a93e3deec09f290070d9ef8fdb85a4c5c393dd8ca924d8921d5a3"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "941327317f9700317d228a75032c9164f36eec098521a6f9c8648e335e6ac276"
    sha256 cellar: :any,                 arm64_ventura:  "1bd1e3e23cea9946abf28ef87c8d0d355183c2da12293ebc61e623df322a7636"
    sha256 cellar: :any,                 arm64_monterey: "ebc150ce93e3a7d946da05fbd47d451846feee1e5f04ba1de33b35ff35b42805"
    sha256 cellar: :any,                 sonoma:         "180f80eb3d4674bd69f71e18514cd086552b8479e6f9f8d2a4538464aba782bb"
    sha256 cellar: :any,                 ventura:        "55c944b2a09258a047656e1bc5628f19a580d91ab0f80b40e856f76d274a6302"
    sha256 cellar: :any,                 monterey:       "ce716b06d1c64f945e72edc1da0d422ac9f9396b8ead88ec4e300663a7ce9bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e345a78c794e4ab7f59d76a99053dd6d15e6008ed67db657c7d0e8e184a185e6"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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
