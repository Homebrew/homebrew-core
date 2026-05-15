class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7980c77acbbf460d6de7df1d30b2f2d9da550db1512d0e828623851c687b238a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d340c3d7d69f63ca3a62acdf15507e826ec2d5e0575473b2505f5a02bc9a7a8b"
    sha256 cellar: :any,                 arm64_sequoia: "ad49f39875cf7a1a8e3b348132d85a33ad8fa2ed0be26c5272ec733b9e4c4a24"
    sha256 cellar: :any,                 arm64_sonoma:  "95d502541be4c3defc9508992892d8ed2a58d517e16aae6483214656b51cb568"
    sha256 cellar: :any,                 sonoma:        "2647a585db77101a817f85a97f2b3db2afc975542738948ca6de71e4339df634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c252b87ec062aff319915620efcb25b2eac7d0b10c5bb979502c4d112b289d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3698d14dc6187358d69fb7f636fe5d2b48a75afd9a2fb49129faf0ec4f5b1df0"
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
