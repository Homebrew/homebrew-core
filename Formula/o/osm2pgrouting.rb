class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3d3042aa0dd30930d27801c9833ebfbe16eba0ab0e5d6277636ce17b157f2a0f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a91a2713349eee362e0573e68b3ec50eb81b9f9cfcb2eef36b9e487df9311da5"
    sha256 cellar: :any,                 arm64_sequoia: "aea29e697c550c06589149f97088db0dca3cf7ebd577f62bd3901eb7ea042c49"
    sha256 cellar: :any,                 arm64_sonoma:  "1eb36bc2d0a5fd533413f64d56b4a076636c42a6e56cc08833aae60a9eabc8d0"
    sha256 cellar: :any,                 sonoma:        "dabb062d43c2eb3c333325fc23e21c0c8ef4f10cf1cc25702fea5ef6971a3479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca30d07f2c57c79fe534fe378a27df5be505ee58f30abb0295e5985650dbb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f6bed7ff0a1a0bfffc5c4a25a5e5874cb5fbad7c151ec861916bd8bf63d70c"
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
