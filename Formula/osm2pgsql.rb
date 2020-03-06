class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.2.1.tar.gz"
  sha256 "0d38f5f4264387bd42bd632f37f726aed85a854eb81192be53a13b3d0879c7b9"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "2ab5eee6c497dbcb9cb7717dd7ed7b8176a740600008e04cc6340f81b071997d" => :catalina
    sha256 "e2eb99125e45cc1dbdeee3aaa9110ed1cd88c16bf9551714379097369e923c6b" => :mojave
    sha256 "a2972343e9007b2c1f353c010ea7dbb7b36744f28e8e310c68393fc03a6407bf" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "lua"
  depends_on "luajit"
  depends_on "postgresql"
  depends_on "proj"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                     "LUA_VERSIONS5 #{lua_version}"

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
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end
