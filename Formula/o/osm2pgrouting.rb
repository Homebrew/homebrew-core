class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3d3042aa0dd30930d27801c9833ebfbe16eba0ab0e5d6277636ce17b157f2a0f"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3fcf96514a000c9139b5361106f7f6d13a245d1c4cb941a72fb6cf177e51c319"
    sha256 cellar: :any, arm64_sequoia: "ce21e2db984453b057c3b27c6473d51bb3bcbc3592dfc824e7e9a454b6c92c1f"
    sha256 cellar: :any, arm64_sonoma:  "1ad753634925bf6a104e0b1049c911ba1e9b8337a07d495302d403f6e3e7e89d"
    sha256 cellar: :any, sonoma:        "606849765be539269c54407d04507121553bda54c02394eff2b5eefaae3f0e0e"
    sha256 cellar: :any, arm64_linux:   "7a555b3812f8e118a4bba01ab1cc3e194f0737757cbee3810750543431c4d545"
    sha256 cellar: :any, x86_64_linux:  "25fb5e4ad5b65e7f5428453c3b8be6f970b69af1bc7b665752b5c6ec4e9e0f79"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  uses_from_macos "expat"

  # Support newer libpqxx
  patch do
    url "https://github.com/pgRouting/osm2pgrouting/commit/7622f12b7e6d9e290315609503d090534c2c7df8.patch?full_index=1"
    sha256 "1ce55a33162d7784443d3fb14f8f2238a8080c1dd5af25a6af7d75a2a4770708"
    type :unofficial
    resolves "https://github.com/pgRouting/osm2pgrouting/pull/328"
  end

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(formula_opt_prefix("expat"))}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end
