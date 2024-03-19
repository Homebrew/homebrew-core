class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/refs/tags/1.11.0.tar.gz"
  sha256 "6b46313813b816f15ce906c04cd4108bbb05362740e0a1a8889055f4e25977d2"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "98724fad7da02aabf3d1be53779806ccd18beb4c178afd365e9dba5745b50b50"
    sha256 arm64_ventura:  "af879fd547cc43d4d8ecd4357be903fc96275aed727fda14a29347d25dadca60"
    sha256 arm64_monterey: "cab73265911a6a15a1ae223a78355cd460e8d69887934a0d8d8597f83eb9e8ee"
    sha256 sonoma:         "60cd245520c1256c0c2c3639fd2d583909a8e8614156e259f5f667d9b962970b"
    sha256 ventura:        "f8a13291c73bafa5312936c2c9e2b788bb9f2ecbe8e71b22acf56a08476fc9c8"
    sha256 monterey:       "c5b1a439f525c4c30b307db88c2b1b659030be40d6fdc860d622c1d1003f5dd5"
    sha256 x86_64_linux:   "b90936c83143fea34b290dcb0c7a8f161f2e36cea7710be3761004458bbca9d7"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "nlohmann-json" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "libpq"
  depends_on "luajit"
  depends_on "proj"

  uses_from_macos "expat"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    args = %w[
      -DWITH_LUAJIT=ON
      -DUSE_PROJ_LIB=6
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
