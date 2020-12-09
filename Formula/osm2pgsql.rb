class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.4.0.tar.gz"
  sha256 "403e25a0310d088183a868d80e5325dceee88617d0df570056e50a2930905369"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "b9ec821f7fedd112073c18f310cca35a30ad4c7abf7e89032851e51e5b503249" => :big_sur
    sha256 "b217411f0e467c6304373c4fd255c4616bbd549e27deaad1572ebd3403621874" => :catalina
    sha256 "e0a6ae0c4a88dbcd7f69b7fb7996a22f4a29bdb306f578e65e8e3952a3522450" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit"
  depends_on "postgresql"
  depends_on "proj"

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
    assert_match "Connecting to database failed: could not connect to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
