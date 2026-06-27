class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/osm2pgsql-dev/osm2pgsql/archive/refs/tags/2.3.0.tar.gz"
  sha256 "334c19fd58140e48216ec842fd63d7a978c7a2aea034858c2a62f32ad9e94c06"
  license "GPL-2.0-or-later"
  head "https://github.com/osm2pgsql-dev/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "e37f0f7faa660da242b9569b6971935388e2c1a6469bfc5d868a16373b3bc06a"
    sha256 arm64_sequoia: "ac326d986900426dbd5ea9f41ef2ed5c1a26c8bd930cef6e4f5130589f12ef0d"
    sha256 arm64_sonoma:  "6884ec06898886de0aba2c38f77e4dc1b2d667224e1ea1fbd45e33562be9c406"
    sha256 sonoma:        "ee161d2c6e27603fb420887cf687f054df6085e91bfefec6d21ebf6d977cceff"
    sha256 arm64_linux:   "6be2f1a8e33b3d3caab7ea0e5f7bc9f9ed03b74512cb749a0ac00fa14868646f"
    sha256 x86_64_linux:  "6b9d43a639372f34c18881ad5b2d412cc2e5c50534982a02c382e4a56e704bb5"
  end

  depends_on "boost" => :build
  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "libosmium" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build
  depends_on "protozero" => :build

  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Remove bundled libraries
    rm_r(Dir["contrib/*"])

    args = %w[
      -DEXTERNAL_CLI11=ON
      -DEXTERNAL_FMT=ON
      -DEXTERNAL_LIBOSMIUM=ON
      -DEXTERNAL_PROTOZERO=ON
      -DWITH_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
    assert_match "ERROR: Connecting to database failed", output

    assert_match version.to_s, shell_output("#{bin}/osm2pgsql --version 2>&1")
  end
end
