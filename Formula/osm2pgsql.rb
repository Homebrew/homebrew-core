class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.7.1.tar.gz"
  sha256 "76c303bfb28440eee546d0f7327565a08d6dac20a915f95dbb4bf21f2e691141"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "42b1c3711449792319d51bab3d57743da47b1648b597481f040e12300a04ff20"
    sha256 arm64_big_sur:  "fccefa87d015f6131baba7e10e3bfe4bc17b66a8c85851643353e26bf65a6809"
    sha256 monterey:       "dc98e45445bcdd11cbbbccad19594cbe70faf37c9ecac1826de0d4c3097ce718"
    sha256 big_sur:        "ebd1379c5fe5d117f785d0c1432331848fe3d3737dfbdea692b5e9b1e20bc87b"
    sha256 catalina:       "d3deafd08284c58a1a8b3113db7e378ea22c0099aa76512fbf35d45558cd80ce"
    sha256 x86_64_linux:   "49a0beb5c343eb5c9fc3b8a3ec6d2835aaab2c7c0db0fa0d5725ce99f968baac"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
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

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "-DUSE_PROJ_LIB=6", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
