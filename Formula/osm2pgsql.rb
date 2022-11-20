class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.7.2.tar.gz"
  sha256 "94c72ceb3c401c816499339f8765c62efbf40685a798dcdf9a4bf7dbedf6c7a5"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b69ab621eea80e4099cd8109ae7b2d3eae11875106a74f5134cc055010c7cd0c"
    sha256 arm64_monterey: "e03099e841fef4d261659e909b4b8d0b77d81c9cd2cb443ab8fcd235ad568bc0"
    sha256 arm64_big_sur:  "813f3040c488c35aeb3f08693eb1f1b15e88ce8aa933aac1345b49caca866f2f"
    sha256 ventura:        "eaac6fb21eab1d50123aadfcf147702be5fdbbec712dd2cd3248d04926042186"
    sha256 monterey:       "e80dd6f6e18e8faa9010c0cfe39fb44f12af9cff5c44d083f589d8de7f0222ac"
    sha256 big_sur:        "2eea99b22a1cd595e35f2d2fbdd1aad2b9a3a8dc5901d83c12088110d6802e40"
    sha256 catalina:       "1b8542d88aeec98a4c32b078acf808b32b822097dfe6d1b9e91066a7e223b5a7"
    sha256 x86_64_linux:   "b47bee3ada1268932e201b4b65d8930a61eee664581a5178f5f2cca9d6a072d8"
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
