class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "3a76ed8c8481e5499c8fedbba3b6af4f33f73bbbfc4e6154ea50fe48ae7054a9"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9316f8b18ae49b45f2e5af2561922516d160ad1b06d92588efb49fbd33371eaa"
    sha256 cellar: :any,                 arm64_sequoia: "b76a693725d795739c43ba199281f5c8fc9447c5595c4e2096a7326b6b138327"
    sha256 cellar: :any,                 arm64_sonoma:  "061f730fc1a9bfdfeb38918fb8d41da61aec6a9b93099284c52e864751703639"
    sha256 cellar: :any,                 sonoma:        "b585b813845a34476b2fb889f43371528f7f7dfa30f092715376045f8251eb58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea304eef56c7f286511b75eb636ebfffe112ab2c0f7f250c9d1906b392dc08e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e38194ee23ba42898fb7940536af52acfd5393bc79598402652af074a925c59a"
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
