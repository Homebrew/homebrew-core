class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7980c77acbbf460d6de7df1d30b2f2d9da550db1512d0e828623851c687b238a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c594f9f9ef9f7dd27e3decdc3e17f52b040836ba8574901414134d1c94666ac0"
    sha256 cellar: :any,                 arm64_sequoia: "be34804e33a4dc5106e58b9e97eecefb2cd162842c8106bf19d51b36976fceb1"
    sha256 cellar: :any,                 arm64_sonoma:  "711e33588946976ca7e2e68e9f1f42f6ac5975e9c814f62ab126a224610776da"
    sha256 cellar: :any,                 sonoma:        "d3d8c1f5652b522195c764a951abf041b962308757953c45caac2ec79195f15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c251ca8a96cb5020fa83e406ed3aaccf1ff5c93d43284a86876ef62475cfc1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc4f8e794f3b8619d5dd0c24c61b75077cb775849cbc1442b9bd9fb07d36f744"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
