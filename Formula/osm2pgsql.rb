class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.2.2.tar.gz"
  sha256 "fc386fc996f24e67cbfb4963de438b2a80c82c9a46f6ca17ade69c7d562d8680"
  license "GPL-2.0"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "4780322e6a538730d945e40f3be991101a33e7326d4e0c847f0bd86237ae78b1" => :catalina
    sha256 "d2a2fb8456cc3f62e16ea412c27beef6681036ea64a33a0eb3b6a70e0b4069b9" => :mojave
    sha256 "4154c1bd9f91b7f72df47570a36208b5ae3b233c7b200dce4d4ce5a99d05a3a0" => :high_sierra
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
