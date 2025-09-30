class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3a76ed8c8481e5499c8fedbba3b6af4f33f73bbbfc4e6154ea50fe48ae7054a9"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "3315f86d657d685cfaf5e1f38277f0542b330f1b7cd733ee39f040f72e0289f3"
    sha256 cellar: :any,                 arm64_sequoia: "7461510ebcdfa1d486b69e15595105eb324bd15c9a4e6339b811c42b5a0e7ffe"
    sha256 cellar: :any,                 arm64_sonoma:  "fe78194e9aa2964afbc350073fd162a2fdc75bd6495faf3fd70949e58cd494b7"
    sha256 cellar: :any,                 arm64_ventura: "0865ee2f7d54ac95a1ed2981e1e0f4440757163881dcb1a56fff16267ea1b689"
    sha256 cellar: :any,                 sonoma:        "1d94935f700e30bb7b65234701104deea79fdf34cd68be53b01b94e36f9a221c"
    sha256 cellar: :any,                 ventura:       "ae0525b18cc02254813fc116b75df743a637485e32d34a047dfbbb3fa894566f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214c62abaed4acdc317d89a83681fa13e7798f3e79b82b6da59ee4374d0b088a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4deb169fe2a9cc48ddd8963591cf758b0c5f895bfa3562416ac5d538963ccd42"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "protozero" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    protozero = Formula["protozero"].opt_include
    args = %W[
      -DPROTOZERO_INCLUDE_DIR=#{protozero}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.opl").write <<~OPL
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    OPL
    system bin/"osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
