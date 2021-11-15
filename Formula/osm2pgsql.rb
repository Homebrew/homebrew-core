class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.5.1.tar.gz"
  sha256 "4df0d332e5d77a9d363f2f06f199da0ac23a0dc7890b3472ea1b5123ac363f6e"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "3885a6a5ae3f0bbc1906d19048f0d352f52ca2ff54ab150c437d07b6c8775df0"
    sha256 arm64_big_sur:  "38b8d470e385856ca0a5aeb452c0c5f7714495b9b50bd241a12a3dbf60f8f07c"
    sha256 monterey:       "8ac78af9ff2d91016b576e3415c2c019ad58ee53f60ff1dee46e7416b346068d"
    sha256 big_sur:        "e4d3b73be00cfafd57ef0ba98121a8ffe544aae106c3fe91dfe33195e69a2daa"
    sha256 catalina:       "1d25fa90f24352efd87936ea0e25a33a55204949e3b360e8eecf5398d5765069"
    sha256 mojave:         "031cfa9cdda3eb6e2273b0c682058e5d3acddfd197a32aa60967540a3244b6cc"
    sha256 x86_64_linux:   "95bbcae74853dd3375a2984d6d7ca871e58bac5ebac029d844ac5bb0e6f55b56"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj@7"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/openstreetmap/osm2pgsql/issues/922
    # and https://github.com/osmcode/libosmium/issues/277
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
