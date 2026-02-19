class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/osm2pgsql-dev/osm2pgsql/archive/refs/tags/2.2.0.tar.gz"
  sha256 "567dad078f8a66d6d706ac1876b5251b688109d16974909d89ce2056d6e9f258"
  license "GPL-2.0-only"
  head "https://github.com/osm2pgsql-dev/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ae644af87377ab7b3929748cf15cf4151b96e3e960195062dfae930a9ef92072"
    sha256 arm64_sequoia: "da139f76e7af7412be8e7602dba9f505c7a340a83cbd1bad2a56c047cd69c4a6"
    sha256 arm64_sonoma:  "eb336eca001d75bf3285581214dbcddd702aa81cd657a1a9bdf74bc9e8f4e9d1"
    sha256 sonoma:        "f969b377e07e963a6389c7595cc67da42977cf68b569a34301a94cfc6ce1e69d"
    sha256 arm64_linux:   "c28a695b8b96dd3a35f11a2e8be256245e930dc2d260fd6b717fe72d946f6712"
    sha256 x86_64_linux:  "3200c49625f208c5171192dc160c001ce9a205e87050fe7ce41627d997f9e9e3"
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
  uses_from_macos "zlib"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Remove bundled libraries
    rm_r("contrib")

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
