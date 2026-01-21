class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7980c77acbbf460d6de7df1d30b2f2d9da550db1512d0e828623851c687b238a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0e6db503b8a8d7e321e77c2a90b6b987b109cd05b816f8856cef1161d85020e"
    sha256 cellar: :any,                 arm64_sequoia: "22e941da84243f2a688e3893a029e99444806d98868028fbfc672bd19efd276d"
    sha256 cellar: :any,                 arm64_sonoma:  "77c7b703fc6058078fe16a321bc480e7b2446992439b5d00ecfd74cfd89623b4"
    sha256 cellar: :any,                 sonoma:        "1500aa6debfc8685a7a8c3329e419f7939789b59489376a174e260792c7ff17b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0400b2824c0c7d6457be12e8889eb9cab96fbea07df8e08fafb5eaeaeb5fe66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63590187632c0e2c45bc7ffaaadcb7e939504c487ee08c5cca563bb248b91069"
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
