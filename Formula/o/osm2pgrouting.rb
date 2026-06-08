class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3d3042aa0dd30930d27801c9833ebfbe16eba0ab0e5d6277636ce17b157f2a0f"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1fcd4a920e939a6953262a4223c5e73782f6aa17c695e46807cd9b5902b30e51"
    sha256 cellar: :any, arm64_sequoia: "b082dd87b77f015d5021c2079de15629499e59960c9b8ba169905e6350cc1123"
    sha256 cellar: :any, arm64_sonoma:  "422a2b59418f73786569967cb6ffd8bb54b82c650d905e13a2d648d1d09c532a"
    sha256 cellar: :any, sonoma:        "48e74c83ba4f29c30417e18916c580e4359090876e8fae77c2236ea64e2fc078"
    sha256 cellar: :any, arm64_linux:   "2236f7147e6de328dba217b854abc604e6d4f9a6a1287a4fb9b5dffc5fcc0f14"
    sha256 cellar: :any, x86_64_linux:  "5b42f463cb1de46fdf3f64540298e021f8b6878d21cca57713ad957a79315b70"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  uses_from_macos "expat"

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

    # Workaround until upstream fix for newer libpqxx
    # PR ref: https://github.com/pgRouting/osm2pgrouting/pull/328
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 17)", "set(CMAKE_CXX_STANDARD 20)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
