class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3d3042aa0dd30930d27801c9833ebfbe16eba0ab0e5d6277636ce17b157f2a0f"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1e6d63741efd9433243a34fe6eeabac94c997be7bfee53cddc38bdef146ecfd"
    sha256 cellar: :any,                 arm64_sequoia: "79c6fed661046213cde072cb868cf54d4b5957d3df71e06510f3e4510488956b"
    sha256 cellar: :any,                 arm64_sonoma:  "343380fd98246518862587e7d1ee1c9ff2e9a5cf45dfd5f75f603cf6d3086073"
    sha256 cellar: :any,                 sonoma:        "58cc66aa2903ebc7a582e0aee137d8451d265de54d4bce92a7e0176dac015ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd934d5d273ee9a827099f0d9fee6ab760319fc66f0fcd16500b442dcabbf5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ceb7cff82516b6511dd821ffb18aeb0b4c4e58a32f4fbef41ebbc59e02c4b66"
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

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
